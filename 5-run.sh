# !/bin/sh

docker build -t bloated-app -f go-app/bloated-go-app.dockerfile go-app/

docker build -t optimized-app -f 5-optimized.dockerfile go-app/

echo "" > 5-comparison.txt

echo "Non optimised image size:" >> 5-comparison.txt
docker images --format "{{.Repository}} {{.Size}}" | grep bloated-app >> 5-comparison.txt

echo "Optimised image size:" >> 5-comparison.txt
docker images --format "{{.Repository}} {{.Size}}" | grep optimized-app >> 5-comparison.txt