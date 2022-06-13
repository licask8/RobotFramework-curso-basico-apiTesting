*** Settings ***
Documentation     Documentação da API: https://fakerestapi.azurewebsites.net/api/v1/Books
Library        RequestsLibrary 
Library        Collections
Library    String


*** Variables ***
${URL_API}    https://fakerestapi.azurewebsites.net/api/v1/
&{BOOK_15}    id=15
...           title=Book 15
...           description=Lorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\n
...           pageCount=1500
...           excerpt=Lorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\nLorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\nLorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\nLorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\nLorem lorem lorem. Lorem lorem lorem. Lorem lorem lorem.\n
           
&{BOOK_CADASTRO}    id=0
...                 title=teste
...                 description=bla bla bla
...                 pageCount=150
...                 excerpt=testando
...                 publishDate=2022-03-04T10:33:27.732Z    

*** Keywords ***
###SETUP E TEARDOWNS
Conectar minha API
    Create Session    fakeAPI    ${URL_API}  

## ações
Requisitar todos os livros
    ${RESPOSTA}    GET On Session    fakeAPI    Books 
    Log            ${RESPOSTA.text}

# setando variavel para que seja usada em outros testes(Global)    
    Set Test Variable    ${RESPOSTA} 
Conferir o status code
    [Arguments]    ${STATUSCODE_DESEJADO}
    Should Be Equal As Strings    ${RESPOSTA.status_code}    ${STATUSCODE_DESEJADO}
Conferir o reason        
    [Arguments]    ${REASON_DESEJADO}    
    Should Be Equal As Strings    ${RESPOSTA.reason}    ${REASON_DESEJADO} 
    
Conferir se retorna uma lista com "${QTDE_LIVROS}" livros
    Length Should Be    ${RESPOSTA.json()}    ${QTDE_LIVROS}


### Conferências
Requisitar o livro "${ID_LIVRO}"
    ${RESPOSTA}    GET On Session    fakeAPI    Books/${ID_LIVRO} 
    Log            ${RESPOSTA.text}

    Set Test Variable    ${RESPOSTA}
        
Conferir se retorna todos os dados corretos do livro 15
    Dictionary Should Contain Item    ${RESPOSTA.json()}    id             ${BOOK_15.id}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    title          ${BOOK_15.title}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    description    ${BOOK_15.description}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    pageCount      ${BOOK_15.pageCount}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    excerpt        ${BOOK_15.excerpt}  
    ##confere se o valor do atributo vem vazio, pois o valor vem varialvelmente de acordo com as chamadas
    Should Not Be Empty        ${RESPOSTA.json()["publishDate"]}
  

  ## requisição post
cadastrar um novo livro
   ${HEADERS}    Create Dictionary    content-type=application/json 
   ${RESPOSTA}    POST On Session    fakeAPI    Books   
   ##argumentos da requisição 
...                                  data={"id": 0,"title": "teste","description": "bla bla bla","pageCount": 150,"excerpt": "testando","publishDate": "2022-03-04T10:33:27.732Z"}
...                                  headers=${HEADERS}    
    Log                  ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Conferir se retorna todos os dados cadastrados para o novo livro
    Dictionary Should Contain Item    ${RESPOSTA.json()}    id             ${BOOK_CADASTRO.id}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    title          ${BOOK_CADASTRO.title}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    description    ${BOOK_CADASTRO.description}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    pageCount      ${BOOK_CADASTRO.pageCount}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    excerpt        ${BOOK_CADASTRO.excerpt}  
    Dictionary Should Contain Item    ${RESPOSTA.json()}    publishDate    ${BOOK_CADASTRO.publishDate}
  
  