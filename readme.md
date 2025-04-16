# How to Set Up and Run the Docker Compose Environment

This guide will help you set up and run the services defined in the `compose.yml` file.

## Prerequisites

1. **Docker**: Ensure Docker is installed on your system. You can download it from [Docker's official website](https://www.docker.com/).
2. **Docker Compose**: Docker Compose is included with Docker Desktop. Verify its installation by running:
   ```bash
   docker-compose --version
   ```

## Steps to Set Up and Run

1. **Navigate to the Project Directory**
   Open a terminal and navigate to the directory containing the `compose.yml` file:
   ```bash
   cd /Users/diogenesmonegro/Documents/udd/lms
   ```

2. **Start the Services**
   Run the following command to start the services defined in the `compose.yml` file:
   ```bash
   docker-compose up
   ```
   This will:
   - Start the `test_moodle` service, which runs a bash script (`backend.bash`) in an Ubuntu container.
   - Start the `moodle_postgres` service, which runs a PostgreSQL database using the Bitnami image.

3. **Access the Services**
   - The `test_moodle` service is exposed on port `3000`.
   - The `moodle_postgres` service is exposed on port `4000`.

4. **Stop the Services**
   To stop the services, press `Ctrl+C` in the terminal where the services are running. Then, run:
   ```bash
   docker-compose down
   ```
   This will stop and remove the containers, networks, and volumes created by `docker-compose up`.

## Notes

- The `test_moodle` service uses a volume (`test_moodle_data`) to persist data in the `/data` directory.
- The `moodle_postgres` service uses a volume (`postgres_data`) to persist PostgreSQL data in `/var/lib/postgresql/data`.
- Ensure the `backend.bash` script exists in the `/data` directory for the `test_moodle` service to run correctly.

For more information on Docker Compose, refer to the [official documentation](https://docs.docker.com/compose/).