#!/bin/zsh

# Verificar si se proporcionaron archivos para excluir
if [[ $# -eq 0 ]]; then
  echo "Uso: $0 archivo1 archivo2 ..."
  exit 1
fi

# Nombres de archivos que deseas conservar (recibidos como argumentos)
EXCLUIR_ARCHIVOS=("$@")

# Arrays para almacenar archivos a eliminar y a conservar
FILES_A_ELIMINAR=()
FILES_A_CONSERVAR=()

# Iterar sobre todos los elementos en el directorio actual
for archivo in *; do
  # Verificar si el elemento es un archivo regular
  if [[ -f "$archivo" ]]; then
    mantener=true

    # Comprobar si el archivo está en la lista de exclusión
    for excluido in "${EXCLUIR_ARCHIVOS[@]}"; do
      if [[ "$archivo" == "$excluido" ]]; then
        mantener=false
        break
      fi
    done

    # Añadir al arreglo correspondiente
    if [[ "$mantener" == true ]]; then
      FILES_A_ELIMINAR+=("$archivo")
    else
      FILES_A_CONSERVAR+=("$archivo")
    fi
  fi
done

# Verificar si hay archivos para eliminar
if [[ ${#FILES_A_ELIMINAR[@]} -eq 0 ]]; then
  echo "No hay archivos para eliminar."
  exit 0
fi

# Mostrar los archivos que serán eliminados
echo "Archivos a eliminar:"
for f in "${FILES_A_ELIMINAR[@]}"; do
  echo "  $f"
done

echo ""

# Mostrar los archivos que serán conservados
echo "Archivos a conservar:"
for f in "${FILES_A_CONSERVAR[@]}"; do
  echo "  $f"
done

echo ""

# Preguntar por confirmación
read -q "respuesta?¿Estás seguro de que deseas eliminar estos archivos? [s/N]: "
echo

# Procesar la respuesta
if [[ "$respuesta" == [sS] ]]; then
  for f in "${FILES_A_ELIMINAR[@]}"; do
    rm -- "$f"
    echo "Eliminado: $f"
  done
  echo "Eliminación completada."
else
  echo "Operación cancelada. No se eliminaron archivos."
fi
