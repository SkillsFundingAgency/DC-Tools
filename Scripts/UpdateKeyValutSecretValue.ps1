
#Requires -Version 3.0

Param(
    
   [Parameter(Mandatory=$true)] [string] $KeyValutName,
   [Parameter(Mandatory=$true)] [string] $SecretName,
   [Parameter(Mandatory=$true)] [string] $SecretValue,
   
   [Parameter(Mandatory=$false)] [switch] $CopyCurrentTags = $false
)

    [string] $ContentType = "";
    [Hashtable] $Tags = New-Object -TypeName Hashtable;

     try 
        { 
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
            
			[SecureString] $secretval = ConvertTo-SecureString "$($SecretValue)" -AsPlainText -Force            
            
    		Write-Debug " ###################################################" 

            $x = Get-AzureKeyVaultSecret -VaultName $KeyValutName -Name $SecretName -ErrorAction SilentlyContinue

            if(($x)-and($x-ne$null))
            {
                $ContentType = $X.ContentType;
                if ($CopyCurrentTags)
                {
                    $Tags = $x.Tags;
                }
            }
                
            $secret =Set-AzureKeyVaultSecret -VaultName "$($KeyValutName)" -Name "$($SecretName)" -SecretValue $secretval -Tag $Tags -ContentType $ContentType

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
