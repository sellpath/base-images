# base-images
base images

used by /sellpath/sellpath git repo

## Building Docker Images Locally

To build and test the Docker images locally in a way that matches the GitHub workflow, use Docker Buildx for multi-platform builds. The build context for each image is the directory containing its Dockerfile.

### Prerequisites

- Docker with Buildx enabled (Docker version 19.03+)
- QEMU for multi-platform builds (optional, only needed for non-native platforms)

### General Buildx Command

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t <image-name>:<tag> -f <Dockerfile> <context> --load
```
- Replace `<image-name>` and `<tag>` as desired.
- `<Dockerfile>` is the path to the Dockerfile.
- `<context>` is the directory containing the Dockerfile.

### Build Instructions for Each Image

#### 1. run_stage/Dockerfile

**Multi-platform (amd64, arm64):**
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t python_run_stage:local -f run_stage/Dockerfile run_stage/ --load
```
**amd64 only:**
```bash
docker buildx build --platform linux/amd64 -t python_run_stage:amd64 -f run_stage/Dockerfile run_stage/ --load
```

#### 2. ui_run_stage_arm64v8/Dockerfile

**arm64 only:**
```bash
docker buildx build --platform linux/arm64 -t ui_run_stage_arm64v8:local -f ui_run_stage_arm64v8/Dockerfile ui_run_stage_arm64v8/ --load
```

#### 3. build_stage/Dockerfile

**Multi-platform (amd64, arm64):**
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t python_build_stage:local -f build_stage/Dockerfile build_stage/ --load
```
**amd64 only:**
```bash
docker buildx build --platform linux/amd64 -t python_build_stage:amd64 -f build_stage/Dockerfile build_stage/ --load
```

#### 4. postgres/Dockerfile

**Multi-platform (amd64, arm64):**
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t postgres:local -f postgres/Dockerfile postgres/ --load
```
**amd64 only:**
```bash
docker buildx build --platform linux/amd64 -t postgres:amd64 -f postgres/Dockerfile postgres/ --load
```

#### 5. ui_run_stage/Dockerfile

**Multi-platform (amd64, arm64):**
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t ui_run_stage:local -f ui_run_stage/Dockerfile ui_run_stage/ --load
```
**amd64 only:**
```bash
docker buildx build --platform linux/amd64 -t ui_run_stage:amd64 -f ui_run_stage/Dockerfile ui_run_stage/ --load
```

### Running a Built Image

To run a built image and access its shell:

```bash
docker run -it --rm <image-name>:local bash
```

### Notes

- The above commands match the build contexts and platforms used in the GitHub workflow (.github/workflows/docker-publish.yml).
- For multi-platform builds, ensure Buildx and QEMU are set up (`docker run --rm --privileged multiarch/qemu-user-static --reset -p yes`).
- Use `--load` to load the image into your local Docker after build (for testing).
- You can change the image name and tag as needed.

## postgresql test

To test the Dockerfile you've provided, you can follow these steps to build the container image and run it, allowing you to access the shell. Here’s how you can do that:

1. **Build the container image** using the Dockerfile:
   ```bash
   docker build -t my-postgres:custom .
   ```

2. **Run the container** and access the shell inside it:
   ```bash
   docker run -it --rm my-postgres:custom bash
   ```

### Step-by-step Instructions

1. **Open a terminal** and navigate to the directory containing your `Dockerfile` (where your `postgres/Dockerfile` is located).

2. **Build the Docker image**:
   - Execute the following command to build the image. Replace `my-postgres:custom` with your desired image name.
   ```bash
   docker build -t my-postgres:custom -f postgres/Dockerfile .
   ```

3. **Run the Docker container**:
   - Once the build is finished, you can run the container and enter the shell by executing:
   ```bash
   docker run -it --rm my-postgres:custom bash
   ```

### Explanation:
- `docker build -t my-postgres:custom .`: This command builds the Docker image using the specified Dockerfile and tags it as `my-postgres:custom`.
- `docker run -it --rm my-postgres:custom bash`: This command runs the built image interactively (`-it`) and automatically removes the container when it's stopped (`--rm`), starting a bash shell inside the container.

After you run these commands, you should be inside the shell of your PostgreSQL container, where you can further test or explore your setup.
