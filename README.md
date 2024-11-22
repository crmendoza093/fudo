# Fudo

Api para consultar y crear productos.

- Documentación
  - [Que es Fudo](docs/fudo.md)
  - [Que es HTTP](docs/http.md)
  - [Que es TCP](docs/tcp.md)
- [Paso a Paso](#paso-a-paso)
- [Dependencias](#dependencias)
- [Endpoins](#endpoins)

## Paso a Paso

Antes de iniciar:

```shell
bundle install
```

Ejecutar los test:

```shell
rspec
```

Levantar el servidor:

```shell
rackup app.rb
```

## Dependencias

### faker

Para cargar datos iniciales en el array de productos.

### hanami-router

Lo uso como enrutador de mis endpoints, asi evito tener codigo extenso en el `app.rb`.

### json

Para serializar/deserializar los payloads.

### rspec

Para crear las pruebas unitarias.

## Endpoins

Puede usar postman o curl para probar los endpoints.

### Auth

- URL: `http://localhost:9292/api/auth`
- METHOD: `GET`
- PARAMS: Puede consultar en [credenciales](data/users.json).

```json
{
  "username": "<username>",
  "password": "<password>"
}
```

### Products

Si usa postman en el tab autorizacion seleccione `Bearer token` y pegue el token que entrego el endpoint `/api/auth`.

#### Consultar productos

- URL: `http://localhost:9292/api/products`
- METHOD: `GET`
- AUTHORIZATION: `<token>`

#### Crear un producto

- URL: `http://localhost:9292/api/products`
- METHOD: `POST`
- AUTHORIZATION: `<token>`
- BODY:

```json
{
  "name": "Acá va algún nombre"
}
```
