## README

### Versão 1.0 Março 2024
- PEDRO RODRIGUES (CAST.PEDROH.UTIC@SEBRAE.COM.BR)
- TitleRequired.com
- Script automatizado para mover usuários e remover grupos no AD

### Requer:
- Módulo Windows PowerShell para Active Directory

### Para assistência e ideias:
- Website: ophsr.com.br
- Github: 

---

### Conectar-se ao Active Directory

Este bloco de código importa o módulo do PowerShell para o Active Directory, permitindo que o script interaja com objetos no AD.

### Especificar o caminho do arquivo de log

Essa variável `$logPath` define o caminho onde o arquivo de log será criado ou atualizado. O script usará esse arquivo para registrar qualquer erro que ocorra durante a execução.

### Especificar as OUs de origem e destino

As variáveis `$ouOrigem` e `$ouDestino` especificam os caminhos das Unidades Organizacionais (OUs) de origem e destino. O script moverá usuários desativados da OU de origem para a OU de destino.

### Obter usuários desativados da OU de origem

Este comando `Get-ADUser` busca todos os usuários desativados dentro da OU de origem especificada. Os usuários desativados são filtrados com base na propriedade `Enabled`, que é definida como `False`.

### Loop através de cada usuário

O comando `foreach` itera sobre cada usuário desativado encontrado anteriormente. Para cada usuário, o script realiza as seguintes operações:

1. **Remover grupos secundários do usuário:** Para cada grupo do qual o usuário é membro, exceto o grupo primário, o script remove o usuário desativado.
2. **Mover o usuário para a OU de destino:** Após remover o usuário de todos os grupos secundários, o script move o usuário para a OU de destino especificada.

### Se ocorrer um erro

Se ocorrer algum erro durante o processamento de um usuário, o script captura a exceção e a registra no arquivo de log especificado em `$logPath`, incluindo detalhes sobre o usuário e o erro encontrado.
