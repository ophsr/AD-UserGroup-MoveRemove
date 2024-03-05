#################################################################################################################
#
# Version 1.0 March 2024
# PEDRO RODRIGUES(CAST.PEDROH.UTIC@SEBRAE.COM.BR)
# TitleRequired.com
# Automated script to move users and remove groups  AD
#
# Requires: Windows PowerShell Module for Active Directory
#
# For assistance and ideas: ophsr.com.br
# Github: https://github.com/ophsr/AD-UserGroup-MoveRemove
#
##################################################################################################################


# Connect to Active Directory
Import-Module ActiveDirectory

# Especificar o caminho do arquivo de log
$logPath = "c:\log\DisableUsersProcess.log"

# Especificar a OU de origem e a OU de destino
$ouOrigem = "OU=Uni,OU=Domain,DC=domain,DC=corp"
$ouDestino = "OU=Disable,OU=Domain,DC=domain,DC=corp"
$usuariosDesativados = Get-ADUser -Filter { Enabled -eq $false } -SearchBase $ouOrigem -SearchScope Subtree 

# Loop através de cada usuário
foreach ($usuario in $usuariosDesativados) {
    try {
        # Remover grupos secundários do usuário
        $gruposUsuario = Get-ADPrincipalGroupMembership -Identity $usuario
        $PrimaryGroup = Get-ADUser $usuario -Properties PrimaryGroup
        foreach ($grupo in $gruposUsuario) {
            if ($grupo.distinguishedName -ne $PrimaryGroup.PrimaryGroup) {
                Remove-ADGroupMember -Identity $grupo -Members $usuario -Confirm:$false -ErrorAction SilentlyContinue
            }
        }
        # Mover o usuário para a OU de destino
        Move-ADObject -Identity $usuario.DistinguishedName -TargetPath $ouDestino -ErrorAction SilentlyContinue
        
    }
    catch {
        # Se ocorrer um erro, gravá-lo no log
        $errorMessage = "Erro ao processar o usuário $($usuario.SamAccountName): $_"
        Add-Content -Path $logPath -Value $errorMessage
    }
}
