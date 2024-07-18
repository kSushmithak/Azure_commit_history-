#https://centrica-emt.visualstudio.com/AvanadeHub/_git/7Z

#https://dev.azure.com/centrica-emt/Quants/_git/thorn

# Define variables

$organization = "centrica-emt"

$project = "Quants"

$repositoryId = "thorn"

$pat = "Access_Token" # Generate this in Azure DevOps

 

# Base64-encode the PAT

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($pat)"))

 

# Define the date range

$fromDate = "2024-01-01T00:00:00Z"

$toDate = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")

 

# Create an empty array to store commit information

$commitHistory = @()

 

# Define the API URL with date filters

$uri = "https://dev.azure.com/$organization/$project/_apis/git/repositories/$repositoryId/commits?searchCriteria.fromDate=$fromDate&searchCriteria.toDate=$toDate&api-version=6.0"

 

# Make the API call

$response = Invoke-RestMethod -Uri $uri -Method Get -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

 

# Process the response

foreach ($commit in $response.value) {

    $commitInfo = [PSCustomObject]@{

        CommitId    = $commit.commitId

        AuthorName  = $commit.author.name

        AuthorEmail = $commit.author.email

        Date        = $commit.author.date

        Comment     = $commit.comment

    }

    $commitHistory += $commitInfo

}

 

# Export to CSV

$commitHistory | Export-Csv -Path "C:\thron_commit_history.csv" -NoTypeInformation

 

Write-Output "Commit history from January 2024 to present exported to commit_history.csv"
