import-module au

$releases = 'https://pypi.python.org/pypi/mkdocs-material'

function global:au_SearchReplace {
  @{
    'tools\ChocolateyInstall.ps1' = @{
      "(^[$]version\s*=\s*)('.*')" = "`$1'$($Latest.Version)'"
    }
        ".\mkdocs-material.nuspec" = @{
          "(\<dependency .+?`"mkdocs`" version=)`"([^`"]+)`"" = "`$1`"$($Latest.MkDocsDep)`""
        }
     }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases

    $re = 'mkdocs\-material\/[\d\.]+\/$'
    $url = $download_page.links | ? href -match $re | select -first 1 -expand href
    $version = $url -split '\/' | select -last 1 -skip 1

    $download_page = Invoke-WebRequest -UseBasicParsing -Uri "https://squidfunk.github.io/mkdocs-material/getting-started/"
    if ($download_page.content -match "Requires MkDocs.*=\s*([\d\.]+)\.") {
      $dependencyVersion = $matches[1]
    }

    return @{ Version = $version; MkDocsDep = $dependencyVersion }
}


update -ChecksumFor none
