# openpose-docker
This is Dockerfile to build minimal size Image (4 Gb) that you need to run openpose

Ensure that you have `nvidia-docker` installed before you download this image.

To run pose estimation use the following commmand:

```bash
sh run.sh /absolute/path/to/dir/with/images /absolute/path/to/output/dir
```
