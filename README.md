## Mi canción favorita

# Contexto

En el ramo de Medición y análisis dimensional de datos políticos nos dieron una tarea para mostrar nuestro aprendizaje en R. Como la tarea era de temática libre se me ocurrió determinar cual es mi canción favorita.

En la tarea 1 pude ver cuales eran los artistas que más se repetían en mi playlist de canciones favoritas, dando como resultado el siguiente gráfico.

![Top 20 artistas](output/Artista+.png)

Pero, todavía estaba muy lejos de tener al menos un indicio de cual de todas esas canciones es precisamente mi favorita. Así que en esta tarea 2 me propuse saber, al menos, cuál de todas estas canciones es la que más he escuchado. Para eso, descargué mis datos de reproducción de spotify, a continuación les dejo todo lo que hice.

# Tarea 2:

Ya tenemos como base la lista de canciones que contiene mi playlist, junto a todos los datos adicionales que me entregó la API de Spotify. Ahora, el gran problema es que los datos de reproducción que te envía Spotify vienen en formato JSON.

Entre el pánico de no saber trabajar con ese formato, un angel del cielo bajó (Felipe Davis) que es igual de ñoño musical que yo y me recomendó usar https://jsoneditoronline.org/ para transformar los datos a CSV, un formato que ya estoy más familiarizado. (Spoiler: igual tuve problemas con la página, pero fueron solucionados como explicaré más adelante).

Así que como siempre, cargaremos las librerías que utilizaré:

``` r
library(tidyverse) #dios t bendiga tidyverse
library(ggplot2)
```

# Subir los datos de Spotify a R

El primer problema lo encontré cuando quería subir los datos de Spotify. Como eran tantos, la página no soportó y tuve que hace pequeños archivos y luego unirlos. Lo logré unir con este código

``` r
ruta_historial <- "input" # Asegurarse que así se llama la carpeta en el directorio que están trabajando

archivos_historial <- list.files(ruta_historial, pattern = "*.csv", full.names = TRUE)

historial <- archivos_historial |> 
  map_dfr(read_csv)
```
# Juntarla con la otra base de datos y filtrar las canciones

Para juntarlas, llamé a la otra base de datos que ya tenía antes y la filtré solo por el nombre de las canciones. Así, cuando las juntara no se me sumen canciones que no estaban en la Playlist.

``` r
playlist <- read_csv("input/canciones_playlist.csv")

# Dejar solo el nombre de las canciones

playlist <- playlist |> 
  select(track.name)
  
historial_playlist <- historial |> 
  filter(`master_metadata_track_name` %in% playlist$track.name)
```

# Base de datos oficial

Ahora con las canciones filtradas podemos crear nuestra base de datos con el N° de reproducción de cada canción de la siguiente forma:

``` r
recuento <- historial_playlist |> 
  group_by(master_metadata_track_name) |> 
  summarise(
    reproducciones = n(),
    artista = first(master_metadata_album_artist_name)
  ) |> 
  arrange(desc(reproducciones))

write_csv(recuento, "data/recuento_playlist.csv")
```
# Gráficos <3

```{r}
# Canciones más escuchadas

recuento |> 
  arrange(desc(reproducciones)) |>
  head(15) |> 
  ggplot(aes(x = reorder(master_metadata_track_name, reproducciones), y = reproducciones)) +
  geom_col(fill = "#800020") + 
  coord_flip() +
  geom_label(aes(label = artista),
             hjust = 1.05,
             size = 3,
             color = "white",
             fill = "black",
             label.size = 0) +
  geom_text(aes(label = reproducciones), 
            hjust = -0.2,
            size = 3.5) +
  labs(
    title = "Canciones más escuchadas de la playlist <3",
    x = "Canción",
    y = "Número de reproducciones"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(face = "bold", size = 16),
    plot.title.position = "plot"
  )

ggsave("output/canciones_mas_escuchadas_playlist.png", width = 8, height = 6)
```
```{r}

# Artistas con más reproducciones

recuento |> 
  group_by(artista) |> 
  summarise(total_reproducciones = sum(reproducciones)) |> 
  arrange(desc(total_reproducciones)) %>%
  head(15) %>%
  ggplot(aes(x = reorder(artista, total_reproducciones),
             y = total_reproducciones)) +
  geom_col(fill = "#800020") +
  coord_flip() +
  geom_text(aes(label = total_reproducciones),
            hjust = -0.2,
            size = 3.5) +
  labs(
    title = "🎤 Artistas más reproducidos de la playlist",
    x = "Artista",
    y = "Total de reproducciones"
  ) +
  theme_minimal(base_family = "Calibri") +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(face = "bold", size = 16)
  )
ggsave("output/artistas_mas_reproducidos_playlist.png", width = 9, height = 6)
```

Dando como resultado lo siguiente:

