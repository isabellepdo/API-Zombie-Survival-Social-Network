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

## Orientações Técnicas

- Desenvolvido em Ruby on Rails (CÓDIGO-FONTE TODO EM INGLÊS)
- Utilização de banco de dados relacional (PostgreSQL ou MySQL)
- Sistema REST, respondendo aos verbos HTTP (POST, GET, UPDATE, etc)
- Toda a comunicação é feita via JSON
- Não é necessário autenticação
- Utilização do Git para controle de versão
- Testes automatizados
- Documentação completa do sistema, incluindo setup, rotas, exemplos de chamadas à API e decisões arquiteturais

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

A documentação completa da API está disponível em [\[link_para_documentação\]](https://www.postman.com/pdoisabelle/workspace/event-organizer-api/collection/9014600-840028b4-2e03-43f5-88e6-b7595eac1f3c?action=share&creator=9014600).

## Exemplos de Chamadas à API

### Cadastro de Usuário

```json
POST /users
{
  "name": "João",
  "age": 30,
  "gender": "M",
  "latitude": 12.345,
  "longitude": -45.678
}

### Atualização de Localização

PATCH /users/:id/location
{
  "latitude": 12.345,
  "longitude": -45.678
}

### Marcar Usuário como Infectado

PATCH /users/:id/mark_as_infected

### Adicionar Item ao Inventário




