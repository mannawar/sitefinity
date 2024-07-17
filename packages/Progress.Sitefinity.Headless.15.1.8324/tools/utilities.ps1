function Get-PackageVersion($package)
{
    if($package -and $package.Version)
    {
		[convert]::ToInt32($package.Version.ToString().Replace("-beta", "").Replace("-preview", "").Replace(".", ""), 10)
    }
    else
    {
        return 0;
    }
}

function Get-BuildProject($project)
{
    return [Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GetLoadedProjects($project.FullName) | Select-Object -First 1
}

function ApplyProjectTransformations($project)
{
	$transformations = Get-Content "$PSScriptRoot\transformations\Project.transform.json" -Raw | ConvertFrom-Json    

	foreach($item in $transformations.items)
	{
		switch ($item.transform)
		{
			"Remove" 
			{
				$itemNode = $project.Items | Where-Object { $_.ItemType -eq $item.type -and $_.EvaluatedInclude.Split(",")[0] -eq $item.include } | Select-Object -First 1
				if($itemNode)
				{
					$project.RemoveItem($itemNode)
				}

				$itemFilePath = $null
				if($item.type -eq "Content")
				{
					$itemFilePath = Join-Path $project.DirectoryPath $item.include
				}
				if($item.type -eq "Reference")
				{
					$itemFilePath = Join-Path $project.DirectoryPath "\bin\$($item.include).dll"
				}
				
				if($itemFilePath -ne $null -and (Test-Path $itemFilePath))
				{
					try
					{						
						Write-Warning "Deleting '$itemFilePath' from the FileSystem..."
						Remove-Item $itemFilePath -Force
					} catch {
						Write-Warning "Could not delete '$itemFilePath' from the FileSystem!"
					}
				}

				break
			}

			"InsertIfMissing"
			{
				$itemNode = $project.Items | Where-Object { $_.ItemType -eq $item.type -and $_.EvaluatedInclude.Split(",")[0] -eq $item.include } | Select-Object -First 1
				if($itemNode -eq $null)
				{
					$project.AddItem($item.type, $item.include)
				}
				break
			}

			"Replace"
			{
				$itemNode = $project.Items | Where-Object { $_.ItemType -eq $item.type -and $_.EvaluatedInclude.Split(",")[0] -eq $item.include } | Select-Object -First 1
				if($itemNode)
				{
					$project.RemoveItem($itemNode)
				}
				$project.AddItem($item.type, $item.include)
				break
			}
		}
	}

	foreach($import in $transformations.imports)
	{
		if($import.transform -eq "Remove")
		{
			$importNode = $project.Xml.Imports | Where-Object { $_.Project -eq $import.project } | Select-Object -First 1
			if($importNode)
			{
				$project.Xml.RemoveChild($importNode)
			}
		}
	}

	$project.Save()
}

function TransformXML($xml, $xdt, $output)
{
    Add-Type -LiteralPath "$PSScriptRoot\lib\Microsoft.Web.XmlTransform.dll"

    $xmldoc = New-Object Microsoft.Web.XmlTransform.XmlTransformableDocument
    $xmldoc.PreserveWhitespace = $true
    $xmldoc.Load($xml)

    $transf = New-Object Microsoft.Web.XmlTransform.XmlTransformation($xdt)
    if ($transf.Apply($xmldoc) -eq $false)
    {
        throw "Transformation for '$xml' FAILED!"
    }
    
    $xmldoc.Save($output)
    $xmldoc.Dispose()
}

function TransformPackagesConfig($packagesConfig)
{
	if(!(Test-Path $packagesConfig))
	{
		Write-Warning "Could not find packages.config..."
		return
	}

	$transformations = Get-Content "$PSScriptRoot\transformations\packages.json" -Raw | ConvertFrom-Json
	$packagesConfigXML = [xml](Get-Content $packagesConfig)

	foreach($item in $transformations.items) 
	{
		$packageNode = $packagesConfigXML.SelectSingleNode("/packages/package[@id='$($item.id)']")

		switch ($item.transform)
		{
			"Remove" 
			{
				if($packageNode) 
				{
					$packageNode.ParentNode.RemoveChild($packageNode)
				}
				break
			}

			"InsertIfMissing"
			{
				if($packageNode -eq $null)
				{
					
					$packageNode = $packagesConfigXML.CreateElement("package")
					$packageNode.SetAttribute("id", $item.id)
					$packageNode.SetAttribute("version", $item.version)
					$packageNode.SetAttribute("targetFramework", $item.targetFramework)
					$packagesNode = $packagesConfigXML.SelectSingleNode("/packages")
					$packagesNode.AppendChild($packageNode) | out-null
					$packagesSorted = $packagesNode.SelectNodes("package") | Sort id
					$packagesNode.RemoveAll()
					$packagesSorted | foreach { $packagesNode.AppendChild($_) | out-null } 	
				}

				break
			}

			"Replace"
			{
				if($packageNode)
				{
					$packageNode.SetAttribute("version", $item.version)
					$packageNode.SetAttribute("targetFramework", $item.targetFramework)
				}

				break
			}
		}
	}

	$packagesConfigXML.Save($packagesConfig)
}
# SIG # Begin signature block
# MIIs0QYJKoZIhvcNAQcCoIIswjCCLL4CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBrectsOX4q0UrI
# RPLVX9jI6AOGEshwpa0vX/FapV8fPqCCFAswggVyMIIDWqADAgECAhB2U/6sdUZI
# k/Xl10pIOk74MA0GCSqGSIb3DQEBDAUAMFMxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSkwJwYDVQQDEyBHbG9iYWxTaWduIENvZGUgU2ln
# bmluZyBSb290IFI0NTAeFw0yMDAzMTgwMDAwMDBaFw00NTAzMTgwMDAwMDBaMFMx
# CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSkwJwYDVQQD
# EyBHbG9iYWxTaWduIENvZGUgU2lnbmluZyBSb290IFI0NTCCAiIwDQYJKoZIhvcN
# AQEBBQADggIPADCCAgoCggIBALYtxTDdeuirkD0DcrA6S5kWYbLl/6VnHTcc5X7s
# k4OqhPWjQ5uYRYq4Y1ddmwCIBCXp+GiSS4LYS8lKA/Oof2qPimEnvaFE0P31PyLC
# o0+RjbMFsiiCkV37WYgFC5cGwpj4LKczJO5QOkHM8KCwex1N0qhYOJbp3/kbkbuL
# ECzSx0Mdogl0oYCve+YzCgxZa4689Ktal3t/rlX7hPCA/oRM1+K6vcR1oW+9YRB0
# RLKYB+J0q/9o3GwmPukf5eAEh60w0wyNA3xVuBZwXCR4ICXrZ2eIq7pONJhrcBHe
# OMrUvqHAnOHfHgIB2DvhZ0OEts/8dLcvhKO/ugk3PWdssUVcGWGrQYP1rB3rdw1G
# R3POv72Vle2dK4gQ/vpY6KdX4bPPqFrpByWbEsSegHI9k9yMlN87ROYmgPzSwwPw
# jAzSRdYu54+YnuYE7kJuZ35CFnFi5wT5YMZkobacgSFOK8ZtaJSGxpl0c2cxepHy
# 1Ix5bnymu35Gb03FhRIrz5oiRAiohTfOB2FXBhcSJMDEMXOhmDVXR34QOkXZLaRR
# kJipoAc3xGUaqhxrFnf3p5fsPxkwmW8x++pAsufSxPrJ0PBQdnRZ+o1tFzK++Ol+
# A/Tnh3Wa1EqRLIUDEwIrQoDyiWo2z8hMoM6e+MuNrRan097VmxinxpI68YJj8S4O
# JGTfAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB0G
# A1UdDgQWBBQfAL9GgAr8eDm3pbRD2VZQu86WOzANBgkqhkiG9w0BAQwFAAOCAgEA
# Xiu6dJc0RF92SChAhJPuAW7pobPWgCXme+S8CZE9D/x2rdfUMCC7j2DQkdYc8pzv
# eBorlDICwSSWUlIC0PPR/PKbOW6Z4R+OQ0F9mh5byV2ahPwm5ofzdHImraQb2T07
# alKgPAkeLx57szO0Rcf3rLGvk2Ctdq64shV464Nq6//bRqsk5e4C+pAfWcAvXda3
# XaRcELdyU/hBTsz6eBolSsr+hWJDYcO0N6qB0vTWOg+9jVl+MEfeK2vnIVAzX9Rn
# m9S4Z588J5kD/4VDjnMSyiDN6GHVsWbcF9Y5bQ/bzyM3oYKJThxrP9agzaoHnT5C
# JqrXDO76R78aUn7RdYHTyYpiF21PiKAhoCY+r23ZYjAf6Zgorm6N1Y5McmaTgI0q
# 41XHYGeQQlZcIlEPs9xOOe5N3dkdeBBUO27Ql28DtR6yI3PGErKaZND8lYUkqP/f
# obDckUCu3wkzq7ndkrfxzJF0O2nrZ5cbkL/nx6BvcbtXv7ePWu16QGoWzYCELS/h
# AtQklEOzFfwMKxv9cW/8y7x1Fzpeg9LJsy8b1ZyNf1T+fn7kVqOHp53hWVKUQY9t
# W76GlZr/GnbdQNJRSnC0HzNjI3c/7CceWeQIh+00gkoPP/6gHcH1Z3NFhnj0qinp
# J4fGGdvGExTDOUmHTaCX4GUT9Z13Vunas1jHOvLAzYIwggboMIIE0KADAgECAhB3
# vQ4Ft1kLth1HYVMeP3XtMA0GCSqGSIb3DQEBCwUAMFMxCzAJBgNVBAYTAkJFMRkw
# FwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSkwJwYDVQQDEyBHbG9iYWxTaWduIENv
# ZGUgU2lnbmluZyBSb290IFI0NTAeFw0yMDA3MjgwMDAwMDBaFw0zMDA3MjgwMDAw
# MDBaMFwxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTIw
# MAYDVQQDEylHbG9iYWxTaWduIEdDQyBSNDUgRVYgQ29kZVNpZ25pbmcgQ0EgMjAy
# MDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMsg75ceuQEyQ6BbqYoj
# /SBerjgSi8os1P9B2BpV1BlTt/2jF+d6OVzA984Ro/ml7QH6tbqT76+T3PjisxlM
# g7BKRFAEeIQQaqTWlpCOgfh8qy+1o1cz0lh7lA5tD6WRJiqzg09ysYp7ZJLQ8LRV
# X5YLEeWatSyyEc8lG31RK5gfSaNf+BOeNbgDAtqkEy+FSu/EL3AOwdTMMxLsvUCV
# 0xHK5s2zBZzIU+tS13hMUQGSgt4T8weOdLqEgJ/SpBUO6K/r94n233Hw0b6nskEz
# IHXMsdXtHQcZxOsmd/KrbReTSam35sOQnMa47MzJe5pexcUkk2NvfhCLYc+YVaMk
# oog28vmfvpMusgafJsAMAVYS4bKKnw4e3JiLLs/a4ok0ph8moKiueG3soYgVPMLq
# 7rfYrWGlr3A2onmO3A1zwPHkLKuU7FgGOTZI1jta6CLOdA6vLPEV2tG0leis1Ult
# 5a/dm2tjIF2OfjuyQ9hiOpTlzbSYszcZJBJyc6sEsAnchebUIgTvQCodLm3HadNu
# twFsDeCXpxbmJouI9wNEhl9iZ0y1pzeoVdwDNoxuz202JvEOj7A9ccDhMqeC5LYy
# AjIwfLWTyCH9PIjmaWP47nXJi8Kr77o6/elev7YR8b7wPcoyPm593g9+m5XEEofn
# GrhO7izB36Fl6CSDySrC/blTAgMBAAGjggGtMIIBqTAOBgNVHQ8BAf8EBAMCAYYw
# EwYDVR0lBAwwCgYIKwYBBQUHAwMwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4E
# FgQUJZ3Q/FkJhmPF7POxEztXHAOSNhEwHwYDVR0jBBgwFoAUHwC/RoAK/Hg5t6W0
# Q9lWULvOljswgZMGCCsGAQUFBwEBBIGGMIGDMDkGCCsGAQUFBzABhi1odHRwOi8v
# b2NzcC5nbG9iYWxzaWduLmNvbS9jb2Rlc2lnbmluZ3Jvb3RyNDUwRgYIKwYBBQUH
# MAKGOmh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2NvZGVzaWdu
# aW5ncm9vdHI0NS5jcnQwQQYDVR0fBDowODA2oDSgMoYwaHR0cDovL2NybC5nbG9i
# YWxzaWduLmNvbS9jb2Rlc2lnbmluZ3Jvb3RyNDUuY3JsMFUGA1UdIAROMEwwQQYJ
# KwYBBAGgMgECMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24u
# Y29tL3JlcG9zaXRvcnkvMAcGBWeBDAEDMA0GCSqGSIb3DQEBCwUAA4ICAQAldaAJ
# yTm6t6E5iS8Yn6vW6x1L6JR8DQdomxyd73G2F2prAk+zP4ZFh8xlm0zjWAYCImbV
# YQLFY4/UovG2XiULd5bpzXFAM4gp7O7zom28TbU+BkvJczPKCBQtPUzosLp1pnQt
# pFg6bBNJ+KUVChSWhbFqaDQlQq+WVvQQ+iR98StywRbha+vmqZjHPlr00Bid/XSX
# hndGKj0jfShziq7vKxuav2xTpxSePIdxwF6OyPvTKpIz6ldNXgdeysEYrIEtGiH6
# bs+XYXvfcXo6ymP31TBENzL+u0OF3Lr8psozGSt3bdvLBfB+X3Uuora/Nao2Y8nO
# ZNm9/Lws80lWAMgSK8YnuzevV+/Ezx4pxPTiLc4qYc9X7fUKQOL1GNYe6ZAvytOH
# X5OKSBoRHeU3hZ8uZmKaXoFOlaxVV0PcU4slfjxhD4oLuvU/pteO9wRWXiG7n9dq
# cYC/lt5yA9jYIivzJxZPOOhRQAyuku++PX33gMZMNleElaeEFUgwDlInCI2Oor0i
# xxnJpsoOqHo222q6YV8RJJWk4o5o7hmpSZle0LQ0vdb5QMcQlzFSOTUpEYck08T7
# qWPLd0jV+mL8JOAEek7Q5G7ezp44UCb0IXFl1wkl1MkHAHq4x/N36MXU4lXQ0x72
# f1LiSY25EXIMiEQmM2YBRN/kMw4h3mKJSAfa9TCCB6UwggWNoAMCAQICDAlVfkW9
# x62ANl5SfzANBgkqhkiG9w0BAQsFADBcMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQ
# R2xvYmFsU2lnbiBudi1zYTEyMDAGA1UEAxMpR2xvYmFsU2lnbiBHQ0MgUjQ1IEVW
# IENvZGVTaWduaW5nIENBIDIwMjAwHhcNMjMxMDI3MTQ0NTA0WhcNMjQxMDI3MTQ0
# NTA0WjCCAQkxHTAbBgNVBA8MFFByaXZhdGUgT3JnYW5pemF0aW9uMRAwDgYDVQQF
# Ewc1NzQzNTgyMRMwEQYLKwYBBAGCNzwCAQMTAlVTMRkwFwYLKwYBBAGCNzwCAQIT
# CERlbGF3YXJlMQswCQYDVQQGEwJVUzEWMBQGA1UECBMNTWFzc2FjaHVzZXR0czET
# MBEGA1UEBxMKQnVybGluZ3RvbjEcMBoGA1UECRMTMTUgV2F5c2lkZSBSZCBTdGUg
# NDEmMCQGA1UEChMdUHJvZ3Jlc3MgU29mdHdhcmUgQ29ycG9yYXRpb24xJjAkBgNV
# BAMTHVByb2dyZXNzIFNvZnR3YXJlIENvcnBvcmF0aW9uMIICIjANBgkqhkiG9w0B
# AQEFAAOCAg8AMIICCgKCAgEAti//DwNMRD5jZiIBY2iSzvG4R8lBIJv/wB/ZSZQR
# VCCdpGP3/yIivfTv0r0ETxfp7chg8v0Dfy9R+XzK/iy151/CvMKoRTSnc1isAoet
# 4KGQvKoLUZyEItguTTinQtGPVvVUzRPiLuirYcoCA+IFr/NzYhb8gW16emLttgUr
# a+fYPgDXJJf30/MsT52OFFcOhQgOPonUD5FMAqIqLzTUkLRQ2eVZ+sXMNm3GjcrG
# RyeilBeZHYNPip6b/Aql/FvwjFFTZglyMmBPbIzuQs/CcMNJuYqYfwY5Eu2sQaS8
# kbCvzPmYwN+Q0k++zQEBjF+V+PZeohCuAg0Hx+1SSDa3v9yp8lNWcggAb84d3LyT
# brNdNqG3EL9ZYRidFCWBe+/gPVf5uqDG1gLheLvBIvDCNb/8FqoKmwvePYItFMjF
# /sjsOSmDVIdadSMzMuUV2+mNGaD7p1oxdX5wjjhl1j9foYFSGf4Q+Tev1w12p2nT
# EUp5WHPg8ssAnDXZU1OWgjKtPJRWE1T9+kQ6rsPSEosrlKYal1OByTetbXgWO+ug
# JtpSdUmZJYfr4x02ISrBNXiiSv5knkugW/DOWYsfEK89nO7/buboCAOawTCKR4L+
# AM/T/C6rlU8qgNMbOR8bqb9lNexUihiSJgr1Qv5L5onDFam4+6KBHm1l8GGvbOFE
# 46MCAwEAAaOCAbYwggGyMA4GA1UdDwEB/wQEAwIHgDCBnwYIKwYBBQUHAQEEgZIw
# gY8wTAYIKwYBBQUHMAKGQGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2Fj
# ZXJ0L2dzZ2NjcjQ1ZXZjb2Rlc2lnbmNhMjAyMC5jcnQwPwYIKwYBBQUHMAGGM2h0
# dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjQ1ZXZjb2Rlc2lnbmNhMjAy
# MDBVBgNVHSAETjBMMEEGCSsGAQQBoDIBAjA0MDIGCCsGAQUFBwIBFiZodHRwczov
# L3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAHBgVngQwBAzAJBgNVHRME
# AjAAMEcGA1UdHwRAMD4wPKA6oDiGNmh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20v
# Z3NnY2NyNDVldmNvZGVzaWduY2EyMDIwLmNybDATBgNVHSUEDDAKBggrBgEFBQcD
# AzAfBgNVHSMEGDAWgBQlndD8WQmGY8Xs87ETO1ccA5I2ETAdBgNVHQ4EFgQU7p0c
# BhDts35gdtky7W7Q98ahMdMwDQYJKoZIhvcNAQELBQADggIBAFhaPMCi/R/Waf0/
# th1H3b4pDSyZrd+kVwuejUBjVxyKOWLk9/7BG3mQHbo4WKxrorS57I4VZCWHWvZb
# iM3N4NzoB18WwCcSz9US9uU9LG2rP96tRPJkSU506p9dm3BKar6fqVFhIXnV39Ya
# JeKtmSVuzLxzUXQsfFUBkIoSdhfXHWsZ4yds9JLnK5JRJhS2IiiKpyBPdMvQruzd
# iYLIvLlmyr64yrpAPL+P1BsYhYobtuAsikatNQ/qV42td5bfifPOayZd+yjBK+Xa
# 4MF29YVfQp5MdIxHaKtpmj9BkbQR4068E3ks7HaDJvY4rdMBmx6isb0ZAXg8QFC1
# 73F5z116oSW9VjnSatJMlIF0kz3yKoZCyvqe5hAm3kCKNdbHXKn0NLO2rr3YAQ+0
# HAdSYe/YmAi/wNMyYZJ4KqSvoNbQFOc0cPmo16PlaoZei8VVZ8alGtv63T7VLHP+
# QUUkUDj89riHFFxhh6nwqLZ+lcPI5CqkhvjaJl+2hUQGIFKfPrnHhrokj6vih9y/
# DQGSHvzX+7x5+GNJ19ZnBYkic+E1oqJdFQklvdtzvbe2JC/OKSovMIGdMyPKiKy4
# BYGurmTMTCevRFH8XqQhhbjbfSkOkH65kxxMg98NqYmOn6HZgDRNU+b9Qy5C8giu
# 0dbH+yz3rM8uf8q7SIbR4iPpCe9OMYIYHDCCGBgCAQEwbDBcMQswCQYDVQQGEwJC
# RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEyMDAGA1UEAxMpR2xvYmFsU2ln
# biBHQ0MgUjQ1IEVWIENvZGVTaWduaW5nIENBIDIwMjACDAlVfkW9x62ANl5SfzAN
# BglghkgBZQMEAgEFAKCBzDAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgAXtsYtoM
# p/ceevRdfoqXZsKgVfWEFYy+3AL+iNpxSkIwYAYKKwYBBAGCNwIBDDFSMFCgMIAu
# AFAAcgBvAGcAcgBlAHMAcwAgAFMAaQB0AGUAZgBpAG4AaQB0AHkAIABDAE0AU6Ec
# gBpodHRwczovL3d3dy5wcm9ncmVzcy5jb20vIDANBgkqhkiG9w0BAQEFAASCAgBe
# a+rGGNy7mgtuDiU65Dk7rbc3rG/n7SJdl9jrR25PqZAEdZAd/oPyhfnk23eGABdz
# yKrI9TW/alT8subDE/etdHG/p4Chp7IwGu1A21m0KvxdlSQmHJR/7ubJDdWz+3Vx
# 1lcfta3yBkOXMTpECQDSAyc/knkicsMx+oML7rhM5vOelbcTiUVdVE0HxxhAUN9I
# IkFNXuS9WXyz43QD7V9BznROPNbMGg4UiH4XyXafn0/XKVvgFR7WUOrK5viZvu44
# 32cFhhDB85Hgmvt3IWxrf5+sA4neGr26vA6+a2qOOpfvkKcsSbtrriqVS3U5QjGP
# t2F1b/CYGAH8JmQ63P2pKz6AZ18Vl8Huq42ahK69NkYh4PEhpvNqwX3eLJvnV3U8
# lyCg6MxNAqyBid4BCVHRWxqX5fyAD3bOJkzDlhOtlIhoJoD77SJArEa/fIaPFjM8
# aPqLm61KAB4XGsjvdmX0Hf/GsunpfdAsQEVavGg8QD5xBj6jo5Ci/S4EP8A15kPt
# 9ZfJjzAssSoG7BopSRgaap8zKtdMBw6QAefb9FFYhnKUcjMyrO1I+18NkBt/7jJ9
# OAhhyCyZ0Jz84LxTKv1WhQuFYSMy9jpSlXM2im7uuhCCsz/GvZDEGyn8Cf1lMWAf
# 7Q+5yihFoL/RKOB36u0fMmvJdAl0JQxMFkZ/lbMKj6GCFLIwghSuBgorBgEEAYI3
# AwMBMYIUnjCCFJoGCSqGSIb3DQEHAqCCFIswghSHAgEDMQ8wDQYJYIZIAWUDBAIB
# BQAwggFqBgsqhkiG9w0BCRABBKCCAVkEggFVMIIBUQIBAQYKKwYBBAGEWQoDATAx
# MA0GCWCGSAFlAwQCAQUABCAkXbxhi8vjrO6QosvI804bJrWPDNmEfdzOSNkgxPee
# MAIGZk9CEnISGBMyMDI0MDYxODEzMTA1Ni4zNTZaMASAAgH0oIHppIHmMIHjMQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNy
# b3NvZnQgSXJlbGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJzAlBgNVBAsTHm5TaGll
# bGQgVFNTIEVTTjo0OTFBLTA1RTAtRDk0NzE1MDMGA1UEAxMsTWljcm9zb2Z0IFB1
# YmxpYyBSU0EgVGltZSBTdGFtcGluZyBBdXRob3JpdHmggg8pMIIHgjCCBWqgAwIB
# AgITMwAAAAXlzw//Zi7JhwAAAAAABTANBgkqhkiG9w0BAQwFADB3MQswCQYDVQQG
# EwJVUzEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMUgwRgYDVQQDEz9N
# aWNyb3NvZnQgSWRlbnRpdHkgVmVyaWZpY2F0aW9uIFJvb3QgQ2VydGlmaWNhdGUg
# QXV0aG9yaXR5IDIwMjAwHhcNMjAxMTE5MjAzMjMxWhcNMzUxMTE5MjA0MjMxWjBh
# MQswCQYDVQQGEwJVUzEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMTIw
# MAYDVQQDEylNaWNyb3NvZnQgUHVibGljIFJTQSBUaW1lc3RhbXBpbmcgQ0EgMjAy
# MDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJ5851Jj/eDFnwV9Y7UG
# IqMcHtfnlzPREwW9ZUZHd5HBXXBvf7KrQ5cMSqFSHGqg2/qJhYqOQxwuEQXG8kB4
# 1wsDJP5d0zmLYKAY8Zxv3lYkuLDsfMuIEqvGYOPURAH+Ybl4SJEESnt0MbPEoKdN
# ihwM5xGv0rGofJ1qOYSTNcc55EbBT7uq3wx3mXhtVmtcCEr5ZKTkKKE1CxZvNPWd
# GWJUPC6e4uRfWHIhZcgCsJ+sozf5EeH5KrlFnxpjKKTavwfFP6XaGZGWUG8TZaiT
# ogRoAlqcevbiqioUz1Yt4FRK53P6ovnUfANjIgM9JDdJ4e0qiDRm5sOTiEQtBLGd
# 9Vhd1MadxoGcHrRCsS5rO9yhv2fjJHrmlQ0EIXmp4DhDBieKUGR+eZ4CNE3ctW4u
# vSDQVeSp9h1SaPV8UWEfyTxgGjOsRpeexIveR1MPTVf7gt8hY64XNPO6iyUGsEgt
# 8c2PxF87E+CO7A28TpjNq5eLiiunhKbq0XbjkNoU5JhtYUrlmAbpxRjb9tSreDdt
# ACpm3rkpxp7AQndnI0Shu/fk1/rE3oWsDqMX3jjv40e8KN5YsJBnczyWB4JyeeFM
# W3JBfdeAKhzohFe8U5w9WuvcP1E8cIxLoKSDzCCBOu0hWdjzKNu8Y5SwB1lt5dQh
# ABYyzR3dxEO/T1K/BVF3rV69AgMBAAGjggIbMIICFzAOBgNVHQ8BAf8EBAMCAYYw
# EAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFGtpKDo1L0hjQM972K9J6T7ZPdsh
# MFQGA1UdIARNMEswSQYEVR0gADBBMD8GCCsGAQUFBwIBFjNodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9yeS5odG0wEwYDVR0lBAww
# CgYIKwYBBQUHAwgwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwDwYDVR0TAQH/
# BAUwAwEB/zAfBgNVHSMEGDAWgBTIftJqhSobyhmYBAcnz1AQT2ioojCBhAYDVR0f
# BH0wezB5oHegdYZzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jcmwv
# TWljcm9zb2Z0JTIwSWRlbnRpdHklMjBWZXJpZmljYXRpb24lMjBSb290JTIwQ2Vy
# dGlmaWNhdGUlMjBBdXRob3JpdHklMjAyMDIwLmNybDCBlAYIKwYBBQUHAQEEgYcw
# gYQwgYEGCCsGAQUFBzAChnVodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3Bz
# L2NlcnRzL01pY3Jvc29mdCUyMElkZW50aXR5JTIwVmVyaWZpY2F0aW9uJTIwUm9v
# dCUyMENlcnRpZmljYXRlJTIwQXV0aG9yaXR5JTIwMjAyMC5jcnQwDQYJKoZIhvcN
# AQEMBQADggIBAF+Idsd+bbVaFXXnTHho+k7h2ESZJRWluLE0Oa/pO+4ge/XEizXv
# hs0Y7+KVYyb4nHlugBesnFqBGEdC2IWmtKMyS1OWIviwpnK3aL5JedwzbeBF7POy
# g6IGG/XhhJ3UqWeWTO+Czb1c2NP5zyEh89F72u9UIw+IfvM9lzDmc2O2END7MPnr
# cjWdQnrLn1Ntday7JSyrDvBdmgbNnCKNZPmhzoa8PccOiQljjTW6GePe5sGFuRHz
# dFt8y+bN2neF7Zu8hTO1I64XNGqst8S+w+RUdie8fXC1jKu3m9KGIqF4aldrYBam
# yh3g4nJPj/LR2CBaLyD+2BuGZCVmoNR/dSpRCxlot0i79dKOChmoONqbMI8m04uL
# aEHAv4qwKHQ1vBzbV/nG89LDKbRSSvijmwJwxRxLLpMQ/u4xXxFfR4f/gksSkbJp
# 7oqLwliDm/h+w0aJ/U5ccnYhYb7vPKNMN+SZDWycU5ODIRfyoGl59BsXR/HpRGti
# JquOYGmvA/pk5vC1lcnbeMrcWD/26ozePQ/TWfNXKBOmkFpvPE8CH+EeGGWzqTCj
# dAsno2jzTeNSxlx3glDGJgcdz5D/AAxw9Sdgq/+rY7jjgs7X6fqPTXPmaCAJKVHA
# P19oEjJIBwD1LyHbaEgBxFCogYSOiUIr0Xqcr1nJfiWG2GwYe6ZoAF1bMIIHnzCC
# BYegAwIBAgITMwAAAENMzH30mIta1AAAAAAAQzANBgkqhkiG9w0BAQwFADBhMQsw
# CQYDVQQGEwJVUzEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMTIwMAYD
# VQQDEylNaWNyb3NvZnQgUHVibGljIFJTQSBUaW1lc3RhbXBpbmcgQ0EgMjAyMDAe
# Fw0yNDA0MTgxNzU5MTlaFw0yNTA0MTcxNzU5MTlaMIHjMQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJlbGFu
# ZCBPcGVyYXRpb25zIExpbWl0ZWQxJzAlBgNVBAsTHm5TaGllbGQgVFNTIEVTTjo0
# OTFBLTA1RTAtRDk0NzE1MDMGA1UEAxMsTWljcm9zb2Z0IFB1YmxpYyBSU0EgVGlt
# ZSBTdGFtcGluZyBBdXRob3JpdHkwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
# AoICAQCYCpTwGh/YYGsCBw1Bfzjt10E/fvUWAM3bPMFqjmgQUgDJFoEr9ID5ySOU
# aVWyzUTNFSm1meso2cv8+ccE8fVlwTjdiqwbD0jANyJqCJyc2KO8Y/0lvZmiv7VE
# 1DAmly7BMmBS0130YajxRZA1ASQ3Jj8WFlwWakj+CEoKoJWwRZWPMdDCqFhcaTvS
# i+8KMNYuRGPViXaUAMLSGr2v3fzaanvZzaroWFHs2rW9vXo9nKkvGa/aDa11roYQ
# WgA+NWbu8skNfnKKo4ag37PZnk5VQTMw+xil3xCQHrQjoLwczARhnRQQprXAjIN7
# Pz7PQBKPc+BiGNhIvosiXgsOaRO4eGPJTXLej0v7g5FFJpnE1vfFtWbxDaSgNiSk
# tRN4aXs+piR3ebeQj5CTTgIhlY5EqqUgjrKuDFYmbSnSOsLemD+stF83V0vqvpkq
# C/NOKYX8px2a8KN33OEnh2LMTMw+/B+6fOoZr770JhbJreNMKcJTBt8oQWExfXuF
# vHcgBVocqK32hoXvhPCRQtTx363Ollh8vKeJuZR3M0STpQef32O25SCUa8WxSO6e
# j3AhzHg9jfpE2/zUxuUM29vkwzinGwLE0igSGc8KYkLgzeeAbve5kAIkoFKytVcw
# jPc5WsAIHtrI4ibe/TIL/ExH82i1iXuyTeDA6B4aoLH8jFOO2QIDAQABo4IByzCC
# AccwHQYDVR0OBBYEFIFSqlmU59vkt1dhEyIJQHCygVA6MB8GA1UdIwQYMBaAFGtp
# KDo1L0hjQM972K9J6T7ZPdshMGwGA1UdHwRlMGMwYaBfoF2GW2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUyMFB1YmxpYyUyMFJT
# QSUyMFRpbWVzdGFtcGluZyUyMENBJTIwMjAyMC5jcmwweQYIKwYBBQUHAQEEbTBr
# MGkGCCsGAQUFBzAChl1odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2Nl
# cnRzL01pY3Jvc29mdCUyMFB1YmxpYyUyMFJTQSUyMFRpbWVzdGFtcGluZyUyMENB
# JTIwMjAyMC5jcnQwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcD
# CDAOBgNVHQ8BAf8EBAMCB4AwZgYDVR0gBF8wXTBRBgwrBgEEAYI3TIN9AQEwQTA/
# BggrBgEFBQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9Eb2Nz
# L1JlcG9zaXRvcnkuaHRtMAgGBmeBDAEEAjANBgkqhkiG9w0BAQwFAAOCAgEAI+3t
# MtpW4R3pzYsdyKeYyvhxL3VpL9mAlxiSbhLqPrRg6DTRrKy+l1sNtKGxsxbgqztF
# VgzuvGuGCEwuVJRX1CMnYIk965fF1wJGv031rv1VO8GVqtrnlJn1MnBFU1uaNsDr
# QrTRA2cI+G/SvIaB+cqcFJUavTTIJ+j3sPpcHxuaHDAd89P2svCIxBLvccZQOnN7
# WlAynXRnEvXJCf2nFe0uYlqX2JymvlF5jwJBxdD/0HkSZKB8hqo/exOdQjKVOflf
# Jrl2GIYsy8AohRVCruSRDx7xtYgepn9brEmMr9LNTztTnCUmDwRFL3jCkwyTUQJk
# cLYm3v0C/v5g5UKi0C3RRz/LA5fjZ20imvWjCXh748/NJPi3BdIE4Dc87ol9Pn7R
# WAwt8R3haGK+MPYOS8zIhAzumg81MzEKqGtf02g6yBoRz96QsBmlQW9/Eyd/lixG
# QgqrskjqDNytS4z5RQj5DdiFeftqY/ZrRsLT4cMwI+28qaX5SjqQvsVlInow6VZP
# S4DorNhlnMCAudUJuuNAeIqwdNtK3iz4ydUuzimEBrOBXSrmhcbmnSfHWdeqd+BE
# DzuP7Cbaeqcf7GdiXwusaLs+SxfrmK/bErXmMS0/rXwCWn+JmKDvduaAbu3JLGBD
# UhcR8OQ2o2ib972jnkRuooRuS0VjKgJM6ZngbGExggPUMIID0AIBATB4MGExCzAJ
# BgNVBAYTAlVTMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xMjAwBgNV
# BAMTKU1pY3Jvc29mdCBQdWJsaWMgUlNBIFRpbWVzdGFtcGluZyBDQSAyMDIwAhMz
# AAAAQ0zMffSYi1rUAAAAAABDMA0GCWCGSAFlAwQCAQUAoIIBLTAaBgkqhkiG9w0B
# CQMxDQYLKoZIhvcNAQkQAQQwLwYJKoZIhvcNAQkEMSIEIMrrF33buHcIIo6YiJGD
# fAhJ4C8cq9F95F2vEfTtP/DaMIHdBgsqhkiG9w0BCRACLzGBzTCByjCBxzCBoAQg
# F07+WGQ6IhpoWuB2oDRyiqGOBEeB0p20wOu3uUIFxd4wfDBlpGMwYTELMAkGA1UE
# BhMCVVMxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMp
# TWljcm9zb2Z0IFB1YmxpYyBSU0EgVGltZXN0YW1waW5nIENBIDIwMjACEzMAAABD
# TMx99JiLWtQAAAAAAEMwIgQgYMFY/nkohg352Sa4dc4GTpQLYMEHPz90IrRGUtGC
# rdYwDQYJKoZIhvcNAQELBQAEggIAi+Xj+cvQNxps4dxtC3NFN5ecF3MGcYbJEmoS
# aWaDgixpIVuytKDDyBrmatPIbvf+d4h9PWyx/1MXT73MFlz2R5JAVDuVpXu1ou8K
# wxmw5VNlAQpyxjfFQRowu1/GuWJoSMRTGCy+/lNtb34bF9ebJTbTqxndS9PdHt7N
# JeWuQRYGImEetuvQ8ahZb9P1cjy+Beowx1HqHkaviVFXqvRIQYIibRnm5vnZ+4zG
# Le9h2O+A4zd2bHpl+RpIpdlmbRuFRUbAUpnYyat3g1pOpvPHpF00jkaUpfPzMtJa
# 5E2VfVu0quPeQRojtt4snpnJumTL9MVInN5Cil7n/+l7Z9R/2sY7SsEJpspNdD1i
# Dms2X1CQqhnYkLwyNU9n//M3GmjO9ZU4WvY+k2eG0YijDvnF+2dlny4oq8isTpIp
# i6PRF3SHUCO+xpY6+Z4GEBNULsLFKw8qdu7DhSfAmrq/oFB6A3y++Y8v3r+H0Khu
# X782OAJgF08TdkO2wFhsx8TRAGtxi9ospD3vrEwS2nnezbK1v49E3Qhf++ihh+06
# GG8CWUhQhZd1cG4xd5wN7oDYN2bUqklztON5TtDp1uyNO78F9KBIziokS8KOsV4a
# vFwYrZz39lsI24ypSnrDzZbEGZZeTiCQAaHXzswivbzogtKQ1F0mU+FXwIf/llVA
# 16cICmM=
# SIG # End signature block
