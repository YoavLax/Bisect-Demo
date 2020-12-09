function GetUrl()
{
	param(
	[string]$orgUrl,
	[hashtable]$header,
	[string]$AreaId
	)
	$orgResourceAreasUrl = [string]::Format("{0}/_apis/resourceAreas/{1}?api-preview=5.0-preview.1", $orgUrl, $AreaId)
	
	$results = Invoke-RestMethod -Uri $orgResourceAreasUrl -Headers $header
	if("null" -eq $results){
	$areaUrl = $orgUrl
	}
	else{
	$areaUrl = $results.locationUrl
	}
	return $areaUrl
}
	$orgUrl = "https://dev.azure.com/YoavDefaultCollection-dryrun"
	$personalToken = "gpatnlh2snch3qymw5smkfb3tjshdebxlluskln746wdntl7ukoq"
	
	#Write-Host "Init" -ForGroundColor Yellow
	$token = [system.convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personalToken)"))
	$header = @{autorization = "Basic $token"}
	$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalToken)")) }
	
	Write-Host "List of Team Projects:"
	$coreAreaId = "79134C72-4A58-4B42-976C-04E7115F32BF"
	$tfsBaseUrl = GetUrl -orgUrl $orgUrl -header $header -AreaId $coreAreaId
	
	$projectsUrl = "$($tfsBaseUrl)_apis/projects?api-version=5.0"

	$projects = Invoke-RestMethod -Uri $projectsUrl -Method Get -ContentType "application/json" -Headers $AzureDevOpsAuthenicationHeader

	$projects.value | ForEach-Object {
		Write-Host $_.name
	}
