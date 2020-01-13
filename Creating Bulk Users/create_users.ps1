############################################
# Create_users.ps1                         #
# Create bulk of Users on Acitve Directory #
# version 0.1                              #
# Written by Nicolas Ehrman - HashiCorp    #
############################################

import-module ActiveDirectory

$ADGroups = import-csv -delimiter ';' .\groups.csv
$ADUsers = import-csv -delimiter ';' .\users.csv

foreach($groups in $ADGroups)
    {
        $name = $groups.name
        $samaccountname = $groups.samaccountname
        $category = $groups.groupcategory
        $scope = $groups.scope

    if (Get-ADGroup -F {SamAccountName -eq $samaccountname})
        {
            Write-Warning -Message "A group with the same name already exits"
        }
    else 
        {

            New-ADGroup `
                -Name $name `
                -SamAccountName  $samaccountname `
                -GroupCategory $category `
                -GroupScope $scope
        }
    }

foreach($users in $ADUsers) 
    {
        $username = $users.username
        $password = $users.password
        $displayname = $users.displayname
        $groups_name = $users.groups_name
        $path = $users.path
    
    if (Get-ADuser -F {SamAccountName -eq $username})
        {
            Write-Warning -Message "A user with the same username already exists"
        }
    else 
        {
            New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@yourdomain.local" `
            -Name $displayname `
            -enabled $True `
            -DisplayName $displayname `
            -AccountPassword (convertto-securestring $password -AsPlainText -Force) `
            -path $path 
            Add-ADGroupMember `
            -Identity $groups_name `
            -Members $username `
        }
    
    }

 

