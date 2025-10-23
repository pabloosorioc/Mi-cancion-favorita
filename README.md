
## Mi canción favorita

# Contexto

En el ramo de Medición y análisis dimensional de datos políticos nos dieron una tarea para mostrar nuestro aprendizaje en R. Como la tarea era de temática libre se me ocurrió determinar cual es mi canción favorita.

# Tarea 1:

Para esta tarea 1, voy a comenzar observando las características de mis canciones favoritas. Para su conocimiento, tengo una playlist de canciones que considero como favoritas, pero no la tengo ordenada bajo ningún parámetro. 

Primero, cargaremos las librerías que utilizaré:


```R
library(tidyverse)
library(ggplot2)
library(spotifyr)
library(dplyr)

```
Para la configuración de la API de Spotify, es necesario tener una cuenta de desarrollador en Spotify y obtener las credenciales necesarias (Client ID y Client Secret). Una vez que tengas estas credenciales, puedes configurarlas en R de la siguiente manera:

```R
Sys.setenv(SPOTIFY_CLIENT_ID = 'tu_client_id_aqui')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'tu_client_secret_aqui')
```
Luego, se autentica la sesión con el token de acceso:

```R
access_token <- get_spotify_access_token()
```

Con esto, buscamos el ID de la playlist, en este caso, se puede obtener con el link de la playlist en Spotify. 

```R
playlist_id <- "pon el ID de tu playlist aquí"

# Para obtener las canciones

tracks <- get_playlist_tracks(playlist_id)
```

Este proceso solo me permite obtener resultados para las 100 primeras canciones, por lo que trabajaré con ellas mientras tanto.

Ahora, quiero saber que artista se repite más dentro de las 100 primeras canciones:

```R

```

