param($installPath, $toolsPath, $package, $project)

	. (Join-Path $toolsPath "CommonPropertyValues.ps1") 

	$project.Object.References |  Where-Object { $_.Name -eq $referenceAssemblyName } | foreach { $_.Remove() }

	$project.Save()
# SIG # Begin signature block
# MIIs0QYJKoZIhvcNAQcCoIIswjCCLL4CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDKkyxgD6wkBfJT
# oBr0F7r70igRzQu7F41VAY5zECD6Y6CCFAswggVyMIIDWqADAgECAhB2U/6sdUZI
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
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgYbalMtGw
# xj4vR1v3kme3EOd6Efgva2eP7OyDiAtjJrIwYAYKKwYBBAGCNwIBDDFSMFCgMIAu
# AFAAcgBvAGcAcgBlAHMAcwAgAFMAaQB0AGUAZgBpAG4AaQB0AHkAIABDAE0AU6Ec
# gBpodHRwczovL3d3dy5wcm9ncmVzcy5jb20vIDANBgkqhkiG9w0BAQEFAASCAgCL
# tC6rj+OEN0ZtLS2hxSnz3fhGE7nCxj/FtHFzp3Co78OpajajyozQjYt6+ZQp182R
# JSIB4lbPqRGJf59ui3ebR0+kKLpBvqao8FB+FsbDBlqzmkG3HK9P/cCVr5weOdEc
# raLjzSU55NFq+cdEptx/RFWG/OpPaFxja7hMs/ZfqPjQhkE4pEsCYMDqWsYqMKJt
# YXOBtIDC3k6aW/E9iMHFy48fEdFD2cn0V7Q+WN173M5MIqHltxEKgeTUFeiSi6xe
# tNQajqiTzKj730elhSmqggfllF90GZukjUGlhrT7U9IyymE368MpIvIjUbDzg6ir
# z6S7rqSLHDy1uP8EIykj/M4qQirrDATNaGHhP6zHAdB4tLonbg2HkqHq1njzAGfh
# JaU4z6t2AJErKNT7fqP7c6tizp2qSm3iSncxmVwlmfI8fzzUA/LFQUcVxmz14duY
# naWbpuls6Fw2megA39oRZVVFEmtCLqT58XSr6svPjdcrKfdSvK6lz6kRRhqb3nz9
# PSjfEreZ0cj6kVV/jguxzvziwL930ttXnjHB0w2VpbLRYwwnGnUlgXSf+S7+YEaU
# mxPdZDBzuFJ+E6ZDQoWAKnBgQnaCDlRsCX6HNelKXZmJKCOgjIL2eqNPJeXUGLBA
# dY97/U94QoNeBXjBW/rl14BHc3To/IieY9yREV5OWaGCFLIwghSuBgorBgEEAYI3
# AwMBMYIUnjCCFJoGCSqGSIb3DQEHAqCCFIswghSHAgEDMQ8wDQYJYIZIAWUDBAIB
# BQAwggFqBgsqhkiG9w0BCRABBKCCAVkEggFVMIIBUQIBAQYKKwYBBAGEWQoDATAx
# MA0GCWCGSAFlAwQCAQUABCAgOUHBuleTFKHSMGteNpg776V/e/JBB1hsvzsRx3Ik
# ygIGZk9CEnIvGBMyMDI0MDYxODEzMTI0Mi40ODhaMASAAgH0oIHppIHmMIHjMQsw
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
# CQMxDQYLKoZIhvcNAQkQAQQwLwYJKoZIhvcNAQkEMSIEIGhAZaFtrELXJ1+vdmMJ
# 0CQ/WvYSe9JsOq0cz57ge7WSMIHdBgsqhkiG9w0BCRACLzGBzTCByjCBxzCBoAQg
# F07+WGQ6IhpoWuB2oDRyiqGOBEeB0p20wOu3uUIFxd4wfDBlpGMwYTELMAkGA1UE
# BhMCVVMxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMp
# TWljcm9zb2Z0IFB1YmxpYyBSU0EgVGltZXN0YW1waW5nIENBIDIwMjACEzMAAABD
# TMx99JiLWtQAAAAAAEMwIgQgYMFY/nkohg352Sa4dc4GTpQLYMEHPz90IrRGUtGC
# rdYwDQYJKoZIhvcNAQELBQAEggIAa3Xe9HHYPuhsmM7ZlDXaz56vOY2v0YzyaqHT
# Ws/y1gxfE7ZfyS8OdsQU4xJc1cc0P6hxC6o14JRGLy/EeUdnczN9PErs5ng60OaV
# P1oXkvlQubkuRZ34M9A23+O95ALbRFbHh9WOVZdYzXXlyYZQR/x+DzW1rS9kKDng
# esPIVqe9uiq2XT3YHKeFGZU/QNC4FDiPxGgB/YjC1C2FxxkbpS8mJlluUn/smvMa
# s/COew+AoGaSuMpcByy5jAP3PwiRF7mnRkLMqFf55UHfo0LZa8ZIy3Qatpsx88VR
# hzGbBdhBvv11DZzppGyLFduuptHz9OiBhDWmQ2nGcY0vm1EnTBn6QcxRoRo/dp+y
# oQ/sjQXKaZKzhxaHFQrLnkFx4xWMIHhTCxZUycAJ6BoqxlM2tgVv4yOIC30tRM/p
# UAUVZBauOG1MQfXvN96FpFoKIPewBQ+zT4M0LAaYyM/8p+6IgYyvdkWle0O31NBb
# Ys9rEeLP+QWmpC9ZR35iM9z/QGV3U7W2MQXmVV5cFySBc1zjfjUc3CeSszmx03Z0
# OoJo4t8wt3vSqdG2cUtT9UaeIBaY2d/26VEvTGU5/YVf66MVBxOl3M5V5eSfMJH4
# Dy6aizOSCr1zAhQxOqzw1rYCmv6+P7CtAPpE56UV8KtQFG509CjUyTSGSrN0g5eM
# stGAs1I=
# SIG # End signature block
