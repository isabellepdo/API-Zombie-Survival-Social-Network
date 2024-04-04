# Zombie Survival Social Network (ZSSN) API

## Descrição do Problema

O mundo atingiu seu estado apocalíptico, onde uma pandemia causada por um vírus de laboratório transforma seres humanos e animais em zumbis. Você, como membro da resistência e último sobrevivente com conhecimentos em desenvolvimento de software, foi incumbido de desenvolver um sistema para compartilhamento de recursos entre os humanos não infectados.

## Funcionalidades

O sistema consiste em uma API REST que armazena informações sobre os sobreviventes e os recursos que cada um detém. As principais funcionalidades incluem:

- Cadastro de usuários na base
- Atualização da localização do usuário
- Marcação de usuário como infectado
- Adição/Remoção de itens do inventário de um usuário
- Escambo de bens entre usuários
- Relatórios sobre usuários infectados, não infectados, quantidade média de itens por usuário e pontos perdidos por usuários infectados

## Requisitos de Instalação

- Ruby 2.6.3
- PostgreSQL
- Bundler

## Configuração

1. Clone o repositório:

    git clone https://github.com/seuusuario/zssn_api.git


2. Instale as dependências:

    bundle install


3. Crie o banco de dados e execute as migrações:

    rails db:create
    rails db:migrate


4. Execute os testes:

    rspec


5. Inicie o servidor:

    rails server


## Utilização da API

A documentação completa da API está disponível pelo Postman em [\[link_para_documentação\]](https://www.postman.com/pdoisabelle/workspace/event-organizer-api/collection/9014600-840028b4-2e03-43f5-88e6-b7595eac1f3c?action=share&creator=9014600).

## Exemplos de Chamadas à API

### Cadastro de Usuário

```json
POST /users/create
{
  "name": "Maria",
  "age": 30,
  "gender": "female",
  "latitude": 123.123,
  "longitude": 321.321,
  "username": "maria",
  "encrypted_password": "password"
}
``` 

### Atualização de Localização

```json
PATCH /users/:id/update_location
{
  "latitude": 12.345,
  "longitude": -45.678
}
```

### Resportar Usuário como Infectado

```json
POST /report_user
{
  "user": "maria",
  "whistleblower": "joao"
}
```

### Adicionar Item ao Inventário

```json
POST /add_item
{
  "user": "maria",
  "item": "Água",
  "value": 1
}
```

### Remover Item ao Inventário

```json
POST /remove_item
{
  "user": "maria",
  "item": "Água",
  "value": 1
}
```
### Escambo entre Usuários

```json
POST /barter
{
  "users": [
    {
      "username": "teste1",
      "items": [
        {
          "name": "Água",
          "amount": 1
        }
      ]
    },
    {
      "username": "teste2",
      "items": [
        {
          "name": "Comida",
          "amount": 1
        }
      ]
    }
  ]
}
```
### Relatórios

Porcentagem de Usuários Infectados

    GET /percentage_of_healthy_users

Porcentagem de Usuários Infectados

    GET /percentage_of_infected_users

Porcentagem de Usuários Infectados

    GET /number_of_points_lost_by_infected_users



