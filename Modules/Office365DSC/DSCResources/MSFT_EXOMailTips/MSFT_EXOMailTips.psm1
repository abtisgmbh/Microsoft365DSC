function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Organization,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()] 
        [ValidateSet("Present","Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    Write-Verbose "Get-TargetResource will attempt to retrieve information for Shared Mailbox $($Organization)"
    $nullReturn = @{
        Organization = $Organization
        MailTipsAllTipsEnabled = $null
        MailTipsGroupMetricsEnabled = $null
        MailTipsLargeAudienceThreshold = $null
        MailTipsMailboxSourcedTipsEnabled = $null
        MailTipsExternalRecipientsTipsEnabled = $null
        Ensure = "Absent"
        GlobalAdminAccount = $null
    }
    $OrgConfig = Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                                    -ScriptBlock {
        Get-OrganizationConfig
    }

    if(!$OrgConfig)
    {
        Write-Verbose "Can't find the information about the Organization Configuration."
        return $nullReturn
    }
    $result = @{
        Organization = $Organization
        MailTipsAllTipsEnabled = $OrgConfig.MailTipsAllTipsEnabled
        MailTipsGroupMetricsEnabled = $OrgConfig.MailTipsGroupMetricsEnabled
        MailTipsLargeAudienceThreshold = $OrgConfig.MailTipsLargeAudienceThreshold
        MailTipsMailboxSourcedTipsEnabled = $OrgConfig.MailTipsMailboxSourcedTipsEnabled
        MailTipsExternalRecipientsTipsEnabled = $OrgConfig.MailTipsExternalRecipientsTipsEnabled
        Ensure = "Present"
        GlobalAdminAccount = $GlobalAdminAccount
    }
    Write-Verbose "Found configuration of the Mailtips for $($Organization)"
    return $result
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Organization,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    Write-Verbose "Entering Set-TargetResource"
    Write-Verbose "Retrieving information about Mailtips Configuration"
    $OrgConfig = Get-TargetResource @PSBoundParameters

    # CASE : MailTipsAllTipsEnabled aren't in the right state
    if ($PSBoundParameters.ContainsKey('MailTipsAllTipsEnabled') -and $OrgConfig.MailTipsAllTipsEnabled -ne $MailTipsAllTipsEnabled)
    {
        Write-Verbose "Mailtips for $($Organization) aren't in the right state. Fixing it."
        Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                          -Arguments $PSBoundParameters `
                          -ScriptBlock {
            Set-OrganizationConfig -MailTipsAllTipsEnabled $args[0].MailTipsAllTipsEnabled
        }
    }
    # CASE : MailTipsGroupMetricsEnabled aren't in the right state
    if ($PSBoundParameters.ContainsKey('MailTipsGroupMetricsEnabled') -and $OrgConfig.MailTipsGroupMetricsEnabled -ne $MailTipsGroupMetricsEnabled)
    {
        Write-Verbose "Mailtips for Group Metrics of $($Organization) aren't in the right state. Fixing it."
        Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                          -Arguments $PSBoundParameters `
                          -ScriptBlock {
            Set-OrganizationConfig -MailTipsGroupMetricsEnabled $args[0].MailTipsGroupMetricsEnabled
        }
    }
    # CASE : MailTipsLargeAudienceThreshold aren't in the right state
    if ($PSBoundParameters.ContainsKey('MailTipsLargeAudienceThreshold') -and $OrgConfig.MailTipsLargeAudienceThreshold -ne $MailTipsLargeAudienceThreshold)
    {
        Write-Verbose "Mailtips for Large Audience of $($Organization) aren't in the right state. Fixing it."
        Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                          -Arguments $PSBoundParameters `
                          -ScriptBlock {
            Set-OrganizationConfig -MailTipsLargeAudienceThreshold $args[0].MailTipsLargeAudienceThreshold
        }
    }
    # CASE : MailTipsMailboxSourcedTipsEnabled aren't in the right state
    if ($PSBoundParameters.ContainsKey('MailTipsMailboxSourcedTipsEnabled') -and $OrgConfig.MailTipsMailboxSourcedTipsEnabled -ne $MailTipsMailboxSourcedTipsEnabled)
    {
        Write-Verbose "Mailtips for Mailbox Data (OOF/Mailbox Full) of $($Organization) aren't in the right state. Fixing it."
        Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                          -Arguments $PSBoundParameters `
                          -ScriptBlock {
            Set-OrganizationConfig -MailTipsMailboxSourcedTipsEnabled $args[0].MailTipsMailboxSourcedTipsEnabled
        }
    }
    # CASE : MailTipsExternalRecipientsTipsEnabled aren't in the right state
    if ($PSBoundParameters.ContainsKey('MailTipsExternalRecipientsTipsEnabled') -and $OrgConfig.MailTipsExternalRecipientsTipsEnabled -ne $MailTipsExternalRecipientsTipsEnabled)
    {
        Write-Verbose "Mailtips for External Users of $($Organization) aren't in the right state. Fixing it."
        Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                          -Arguments $PSBoundParameters `
                          -ScriptBlock {
            Set-OrganizationConfig -MailTipsExternalRecipientsTipsEnabled $args[0].MailTipsExternalRecipientsTipsEnabled
        }
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Organization,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Mailtips for $($Organization)"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                           -DesiredValues $PSBoundParameters `
                                           -ValuesToCheck @("MailTipsAllTipsEnabled",
                                                            "MailTipsGroupMetricsEnabled",
                                                            "MailTipsLargeAudienceThreshold",
                                                            "MailTipsMailboxSourcedTipsEnabled",
                                                            "MailTipsExternalRecipientsTipsEnabled",
                                                            "Ensure"
                                           )
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Organization,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $content = "EXOMailTips " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource

