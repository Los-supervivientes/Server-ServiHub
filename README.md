# PROYECTO BACKEND DE SERVIHUB
Proyecto final Backend de Servihub del Bootcamp Desarrollo de Apps Móviles impartido por keepcoding.
- Realizado por el equipo de alumnos **"Los últimos supervivientes"**.

## Contenidos

1. [Descripción](#descripción)
2. [Tecnologías Utilizadas](#tecnologías-utilizadas)
3. [Requisitos](#requisitos)
4. [Instalación](#instalación)
5. [Configuración](#configuración)
6. [Endpoints](#endpoints)
7. [Documentación Adicional](#documentación-adicional)
8. [Contribución](#contribución)
9. [Contacto](#contacto)

## Descripción 
Este proyecto es el sistema backend de ServiHub, una plataforma que conecta clientes con proveedores de 
servicios locales. El backend gestiona clientes, usuarios profesionales, servicios y categorías de servicios a 
través de una API RESTful.

## Tecnologías Utilizadas
- Swift: Lenguaje de programación utilizado para desarrollar el backend.
- Vapor: Framework de Swift para construir aplicaciones web y APIs.
- PostgreSQL: Sistema de gestión de bases de datos relacional.
- JWT: JSON Web Tokens para la autenticación.
- dotenv: Módulo para cargar variables de entorno desde un archivo .env.

## Requisitos
- Xcode (versión 12.x o superior)
- Swift (versión 5.x o superior)
- Base de datos PostgreSQL

## Instalación
1. Clona este repositorio:
    ```bash
    git clone git@github.com:Los-supervivientes/Server-ServiHub.git
    ```
2. Configura las variables de entorno en el archivo `.env` (ver sección [Configuración](#configuración))
3. Inicia el servidor:
    ```bash
    swift run
    ```

## Configuración

1. Crea un archivo `.env` en la raíz del proyecto con el siguiente contenido:
    ```env
    JWT_KEY=tu_jwt_secreto
    API_KEY=tu_ssh_apikey
    DATABASE_URL=postgresql://usuario:contraseña@localhost:5432/tu_base_de_datos
    APP_BUNDLE_ID=tu_bundle_id
    ```

2. Reemplaza los valores de ejemplo con tus datos específicos:

- `JWT_KEY`: Clave secreta para JWT. Debe ser una cadena secreta y segura.
- `API_KEY`: Clave de API utilizada para validar solicitudes. Mantenla privada.
- `DATABASE_URL`: URL de conexión a tu base de datos PostgreSQL, incluyendo el usuario, contraseña y nombre de la base de datos.
- `APP_BUNDLE_ID`: Identificador del bundle de tu aplicación.

3. En Xcode, asegúrate de que tu esquema está configurado para utilizar el archivo `.env` en el custom working directory.

4. Archivo `.env` con el que se ha desarrollado la aplicación:

    ```env
    JWT_KEY=hteNxPnJS3jQm+fy5oCIqzbDXRi2ZbZYgmILIx0/t9E=
    API_KEY=bMUFVs9bRK631yNo/IJxKqkx4IVQ5O1rsO7y9MVMvP6SQ2bqRcuO5DADlPL1Avgy
    DATABASE_URL=postgresql://josebuenocruz@127.0.0.1/josebuenocruz
    APP_BUNDLE_ID=com.mhergon.CloudDragon
    ```

## Endpoints

La API proporciona endpoints para gestionar usuarios, profesionales, servicios y categorías. 
Los detalles completos de los endpoints están documentados en la documentación del proyecto.

Principales Funcionalidades:
- Gestión de Usuarios: Crear, obtener, actualizar y eliminar usuarios y profesionales.
- Gestión de Servicios: Crear, obtener, actualizar y eliminar servicios.
- Gestión de Categorías: Obtener todas las categorías y detalles de categorías específicas.

## Documentación Adicional

Para una documentación más detallada sobre el proyecto, consulta los siguientes recursos:

- [Archivo apiRapi (RapiDoc)](https://drive.google.com/file/d/1Kgz1EgjToYoNBF1VPAaoT0-MSMj9Ekn9/view?usp=sharing)
- [Documentación de la API](https://www.canva.com/design/DAGMZfZKBwA/thRsUePPmAXGV88coK7y5g/view?utm_content=DAGMZfZKBwA&utm_campaign=designshare&utm_medium=link&utm_source=editor)

## Contribución

- Haz un fork del repositorio y crea una nueva rama:
    ```bash
    git checkout -b feature/nueva-funcionalidad
    ```
- Realiza tus cambios y haz commit:
    ```bash
    git commit -m 'Añadir nueva funcionalidad'
    ```
- Haz push a la rama:
    ```bash
    git push origin feature/nueva-funcionalidad
    ```
- Abre un Pull Request.

## Contacto
Si tienes preguntas o sugerencias, por favor contáctanos.

### Colaboradores
- Cristian Contreras - [GitHub](https://github.com/Criscovez)
- Alejandro Gavira - [GitHub](https://github.com/agavgar)
- Rocio Martos - [GitHub](https://github.com/Rociomartos29)
- Diego Andrades - [GitHub](https://github.com/diegoao)
- Jose Bueno - [GitHub](https://github.com/Boncroix)
- Pablo Peragón - [GitHub](https://github.com/PabloPeragon)
