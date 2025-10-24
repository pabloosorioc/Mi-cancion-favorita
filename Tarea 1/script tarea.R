
# Librerías ---------------------------------------------------------------

library(tidyverse)
library(ggplot2)
library(spotifyr)
library(dplyr)
library(purrr)
library(kableExtra)
library(stringr)
library(tidyr)

# Configuración SportifyR -------------------------------------------------

Sys.setenv(SPOTIFY_CLIENT_ID = '5362f1cd7c864b9cac910211e4e2101a')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '64d951af9c864502a11e334b47bd37e2')

# Token de acceso ---------------------------------------------------------

access_token <- get_spotify_access_token()


# Obtener datos de la playlis ---------------------------------------------

playlist_id <- "74K2s9BYNZgJiaKUwJciCL"

#Intento para obtener todas las canciones de la playlist

#obtener las 100 primeras

canciones2 <- get_playlist_tracks(playlist_id)

offset <- 0
limit <- 100
canciones <- data.frame()
repeat {
  batch <- get_playlist_tracks(playlist_id, limit = limit, offset = offset)
  if (nrow(batch) == 0) break
  canciones <- bind_rows(canciones, batch)
  offset <- offset + limit
}

#Unir ambas

canciones_final <- bind_rows(canciones2, canciones)

# La guardamos en el PC

save(canciones_final, file = "data/canciones_playlist.RData")

# Obtener los nombres de los artistas

lista_artistas <- map(canciones_final$track.artists, ~ .x$name)

vector_artistas <- unlist(lista_artistas)

conteo_artistas <- data.frame(artista = vector_artistas) |> 
  group_by(artista) |> 
  summarise(canciones = n()) |> 
  arrange(desc(canciones))

# Guardamos ese archivo

write_csv(conteo_artistas, "data/conteo_artistas.csv")

# Graficamos el top 20

ggplot(conteo_artistas[1:20, ], aes(x = reorder(artista, canciones), y = canciones)) +
  geom_col(fill = "#800020") +  # color burdeo 🍷
  geom_text(aes(label = canciones), hjust = -0.2, size = 4, family = "Georgia") + # etiquetas de cantidad
  coord_flip() +
  labs(
    title = "🎶 Artistas más repetidos en la playlist",
    x = "Artista",
    y = "Número de canciones (incluye colaboraciones)"
  ) +
  theme_minimal(base_size = 14, base_family = "Georgia") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5, size = 16),
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
    axis.text.y = element_text(size = 12),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    plot.background = element_rect(fill = "grey", color = NA)
  )

  
