*** Settings ***
Documentation     Documentação da API: https://fakerestapi.azurewebsites.net/api/v1/Books
Suite Setup       Conectar minha API
Resource          ResourceAPI.robot

*** Test Cases ***

Buscar a listagem de todos os livros (GET em todos os livros)
    Requisitar todos os livros
    Conferir o status code    200 
    Conferir o reason    OK
    Conferir se retorna uma lista com "200" livros
Buscar um livro especifico (GET em um livro especifico)
    Requisitar o livro "15"
    Conferir o status code    200 
    Conferir o reason    OK
    Conferir se retorna todos os dados corretos do livro 15
Cadastrar um novo livro (POST)
    cadastrar um novo livro
    Conferir se retorna todos os dados cadastrados para o novo livro
#TO-DO: Alterar um livro (PUT)
#    - Conferir se retorna todos os dados alterados do livro 150
#TO-DO: Deletar um livro(DELETE)
#    - Conferir se deleta o livro 200

