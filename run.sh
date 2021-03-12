docker run -it \
    -v $1:/openpose/data/ \
    -v $2:/openpose/result/ \
    --rm --runtime=nvidia \
    --name openpose \
    kslavnov/openpose \
    	  --display 0 \
    	  --image_dir /openpose/data/ \
    	  --write_json /openpose/result/json \
    	  --write_images /openpose/result/imgs