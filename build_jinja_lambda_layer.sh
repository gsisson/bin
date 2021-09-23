#!/usr/bin/env bash


LIBRARY_NAME=jinja2
LIBRARY_VER=3.0

LAYER_NAME=layer-${LIBRARY_NAME}-${LIBRARY_VER//./-}
echo LAYER_NAME:$LAYER_NAME

if [ ! -d "${LAYER_NAME}/python" ]; then
  mkdir -p "${LAYER_NAME}/python"
  pip install ${LIBRARY_NAME}==$LIBRARY_VER -t ${LAYER_NAME}/python
  cd "$LAYER_NAME"
  zip -r ../${LAYER_NAME}.zip .
  cd -
fi

echo
echo "# To pubish the Layer run:"
echo "#"
echo "#   aws lambda publish-layer-version --compatible-runtimes python3.7 python3.8 --layer-name $LAYER_NAME --zip-file fileb://${LAYER_NAME}.zip"
echo
