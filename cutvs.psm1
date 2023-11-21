<#
 .Synopsis
  Cuts a video file

 .Description
  
  Cuts a video file. This function uses ffmpeg to cut a video file.

 .Parameter Start
  The output video starts at.

 .Parameter End
  The output video ends at.

 .Parameter FirstDayOfWeek
  The output video duration.

 .Example
   # Cut a video file from Start and to End
   Edit-VideoSource -Start 00:01:23 -End 00:01:33

 .Example
   # Cut a video file from Start and for Duration
   Show-Calendar -Start "March, 2010" Duration 30

#>
function Edit-VideoSource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "Duration")]
        [Parameter(Mandatory = $true, ParameterSetName = "End")]
        [string] $Path,

        [Parameter(Mandatory = $true, ParameterSetName = "Duration")]
        [Parameter(Mandatory = $true, ParameterSetName = "End")]
        [timespan] $Start, 
        
        [Parameter(Mandatory = $true, ParameterSetName = "Duration")]
        [timespan] $Duration,
        
        [Parameter(Mandatory = $true, ParameterSetName = "End")]
        [timespan] $End
    )
    
    begin {
        Write-Debug "Start: $Start, End: $End, Duration: $Duration"
    }
    
    process {
        $directoryPath = [System.IO.Path]::GetDirectoryName($Path)
        $basename = [System.IO.Path]::GetFileNameWithoutExtension($Path)
        $outputBasename = "$($basename)_from_$($Start.ToString('hhmmss'))"
        switch ($PSCmdlet.ParameterSetName) {
            "Duration" {
                $outputBasename += "_for_$($Duration.TotalSeconds)"
            }
            "End" {
                $outputBasename += "_to_$($End.ToString('hhmmss'))"
            }
        }
        $outputPath = Join-Path $directoryPath ($outputBasename + ".mp4")
        switch ($PSCmdlet.ParameterSetName) {
            "Duration" {
                ffmpeg -ss $Start -t $Duration.TotalSeconds -i "$Path" -c copy -map 0 "$outputPath"
            }
            "End" {
                ffmpeg -ss $Start -to $End -i "$Path" -c copy -map 0 "$outputPath"
            }
        }
    }
    
    end {
        
    }
}

Export-ModuleMember -Function Edit-VideoSource
