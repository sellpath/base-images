# base-images
base images

used by /sellpath/sellpath git repo


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