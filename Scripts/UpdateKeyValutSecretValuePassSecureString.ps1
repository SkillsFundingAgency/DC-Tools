
#Requires -Version 3.0

Param(
    
   [Parameter(Mandatory=$true)] [string] $KeyValutName,
   [Parameter(Mandatory=$true)] [string] $SecretName,
   [Parameter(Mandatory=$true)] [SecureString] $SecretValue,
   
   [Parameter(Mandatory=$false)] [switch] $CopyCurrentTags = $false,
   [Parameter(Mandatory=$false)] [switch] $IsDebug = $false
)

    [string] $ContentType = "";
    [Hashtable] $Tags = New-Object -TypeName Hashtable;

     try 
        { 
			Write-Debug "Update Key Vault : $($KeyValutName)";

            if(($KeyValutName-eq$null)-or($KeyValutName.TrimEnd()-eq''))
            {
                throw [System.Exception] "KeyValut : $($KeyValutName) value passed is not valid";
            }
            
            if(($SecretName-eq$null)-or($SecretName.TrimEnd()-eq''))
            {
			    throw [System.Exception] "KeyValut : $($KeyValutName) |  SecretName : $($SecretName) value passed is not valid"
            }

            
            if(($SecretValue-eq$null)-or($SecretValue.TrimEnd()-eq''))
            {
			    throw [System.Exception] "KeyValut : $($KeyValutName) |  SecretValue : $($SecretValue) value passed is not valid"
            }
            
    		Write-Debug " ###################################################" 

            $x = Get-AzureKeyVaultSecret -VaultName $KeyValutName -Name $SecretName -ErrorAction SilentlyContinue

            if(($x)-and($x-ne$null))
            {
				Write-Debug "Found : $($SecretName)";

				if ($x.SecretValueText-eq$SecretValue)
                {
                    Write-Debug "     but same value";
                }     
                else
                {
                    Write-Debug "      !!! Diffrent.";

					$ContentType = $X.ContentType;
					if ($CopyCurrentTags)
					{
						Write-Debug " - Copying Current Tags -";
						$Tags = $x.Tags;
					}
					Write-Debug "Updating";
					$secret = Set-AzureKeyVaultSecret -VaultName "$($KeyValutName)" -Name "$($SecretName)" -SecretValue $SecretValue -Tag $Tags -ContentType $ContentType
					Write-Debug "Updated..";
                }
            }
			else
			{
				Write-Debug "Not Found so Creating";
				$secret = Set-AzureKeyVaultSecret -VaultName "$($KeyValutName)" -Name "$($SecretName)" -SecretValue $SecretValue -Tag $Tags -ContentType $ContentType
				Write-Debug "  Created..";
			}
	    }	  
        catch
        {
            $ErrorMessage = $_.Exception.Message
		    Write-Debug $ErrorMessage
			throw $_.Exception
        }
        finally 
        {      
            $secret =$null
            $x=$null;               
            Write-Debug " ###################################################" 

        } 
