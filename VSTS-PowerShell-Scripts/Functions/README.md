# VCC-DSPA FUNCTION-SCRIPTS

This ReadMe contains high-level descriptions for the function-scripts used for the VCC-DSPA script repository.

## Authenticate

This script reads the 'auth.config' file in the Login directory containing your VSTS credentials and returns an array containing information required to interact with VSTS REST APIs.
*See the ReadMe file in the Login folder for more information about the parameters in the 'auth.config' file.

### Requirements/Parameters

What you need to ensure this function-script works:

```
- 'auth.config' file placed in the Login folder
- Your own VSTS login credentials in the 'auth.config' file replacing the default 'username' and 'password'
- *Optional VSTS 'project' URL parameter while invoking this script will bypass the project selection ( Format: /Project%20Name )
```

### Examples

Invoking In Parent Script (*Argument Optional*)

```
$Authentication = .\Functions\Authenticate.ps1 *-project "/Project%20Name"*
```

Invoking From CLI (*Argument Optional*)

```
.\Authenticate.ps1 *-project "/Project%20Name"*
```


## GetRepoNames

This function-script searches through a directory for all repositories matching the query parameters and returns an array containing the repository names.

### Requirements/Parameters

What you need to ensure this function-script works:

```
- Passed 'location' paremeter that is the file-path of the project folder that contains the repositories to be interacted with.
- 'Pop-Location' immediately after invoking the function-script (Pop-Location in a child script does not seem to want to function correctly)
```

### Examples

Invoking In Parent Script

```
$repoNames = .\Functions\GetRepoNames.ps1 -location $location
Pop-Location
```

Invoking From CLI

```
.\GetRepoNames.ps1 -location "D:\ProjectFolder" >> results.txt
Pop-Location
```


## RemoveGitFolders

This function-script pops into each repository folder whose directory names are in a passed array and deletes the hidden *.git* folders within them.

### Requirements/Parameters

What you need to ensure this function-script works:

```
- Passed '$repoNames' parameter (array of Repository Names to be interacted with)
- Passed '$location' parameter (the project directory for this script to work in)
- 'Pop-Location' immediately after invoking the function-script (Pop-Location in a child script does not seem to want to function correctly)
```

### Examples

Invoking In Parent Script

```
.\Functions\RemoveGitFolders.ps1 -repoNames $repoNames -location $location
Pop-Location
```


## RepoClone

This function-script clones all repositories from a project into a specified location.

### Requirements/Parameters

What you need to ensure this function-script works:

```
- Passed '$gitcred' parameter (Git credentials)
- Passed '$json' parameter (list of all repositories in a project)
- Passed '$url' parameter (VSTS project url)
- Passed '$location' parameter (the project directory to clone the repositories to)
- 'Pop-Location' immediately after invoking the function-script (Pop-Location in a child script does not seem to want to function correctly)
```

### Examples

Invoking In Parent Script

```
.\Functions\RepoClone.ps1 -gitcred $Repository.gitcred -json $Repository.json -url $Authentication.defaultCollection -location $location
Pop-Location
```


## RetrieveAllRepositories

This function-script retrieves a list of all repositories for a project.

### Requirements/Parameters

What you need to ensure this function-script works:

```
- Passed '$username' parameter (VSTS username)
- Passed '$password' parameter (VSTS personal access token)
- Passed '$url' parameter (VSTS project url)
```

### Examples

Invoking In Parent Script

```
$Repository = .\Functions\RetrieveAllRepositories.ps1 -username $Authentication.username -password $Authentication.password -url $Authentication.url
```

Invoking From CLI

```
.\RetrieveAllRepositories.ps1 -username "yourname@domain.com" -password "personalaccesstokenforvsts" -url "https://instance.visualstudio.com/Project%20Name" >> results.txt
```


## Authors

* **Keith Cornell** - *Writer*
* **Rodd Mullett** - *QA Tester*
