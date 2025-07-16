# Cómo Configurar y Ejecutar el Entorno de Docker Compose

Esta guía te ayudará a configurar y ejecutar los servicios definidos en el archivo `compose.yml`.

## Requisitos Previos

1. **Docker**: Asegúrate de que Docker esté instalado en tu sistema. Puedes descargarlo desde [el sitio oficial de Docker](https://www.docker.com/).
2. **Docker Compose**: Docker Compose está incluido con Docker Desktop. Verifica su instalación ejecutando:
    ```bash
    docker-compose --version
    ```

## Pasos para Configurar y Ejecutar

1. **Navega al Directorio del Proyecto**
    Abre una terminal y navega al directorio que contiene el archivo `compose.yml`:
    ```bash
    cd /Users/diogenesmonegro/Documents/udd/lms
    ```

2. **Inicia los Servicios**
    Ejecuta el siguiente comando para iniciar los servicios definidos en el archivo `compose.yml`:
    ```bash
    docker-compose up
    ```
    Esto hará lo siguiente:
    - Iniciará el servicio `test_moodle`, que ejecuta un script bash (`backend.bash`) en un contenedor de Ubuntu.
    - Iniciará el servicio `moodle_postgres`, que ejecuta una base de datos PostgreSQL utilizando la imagen de Bitnami.

3. **Accede a los Servicios**
    - El servicio `test_moodle` está expuesto en el puerto `3000`.
    - El servicio `moodle_postgres` está expuesto en el puerto `4000`.

4. **Detén los Servicios**
    Para detener los servicios, presiona `Ctrl+C` en la terminal donde se están ejecutando los servicios. Luego, ejecuta:
    ```bash
    docker-compose down
    ```
    Esto detendrá y eliminará los contenedores, redes y volúmenes creados por `docker-compose up`.

## Notas

- El servicio `test_moodle` utiliza un volumen (`test_moodle_data`) para persistir datos en el directorio `/data`.
- El servicio `moodle_postgres` utiliza un volumen (`postgres_data`) para persistir datos de PostgreSQL en `/var/lib/postgresql/data`.
- Asegúrate de que el script `backend.bash` exista en el directorio `/data` para que el servicio `test_moodle` funcione correctamente.
- Para ingresar a la terminal del contenedor usar `docker exec -it test_moodle /bin/bash`

Para más información sobre Docker Compose, consulta la [documentación oficial](https://docs.docker.com/compose/).