# 6.0 Setup ---------------------------------------------------------------

# 6.0.1 Pakete laden
# Lade das Paket janitor, skimr und haven
library(janitor)
library(skimr)
library(haven)


# 6.0.2 Daten einlesen
# Lese den Datensatz data/replication_data_ramirez_beilock.csv ein
# und speichere ihn in der Variable replication_data
replication_data <- read_csv("data/replication_data_ramirez_beilock.csv")


# 6.1 Datenbereinigung ----------------------------------------------------

# 6.1.1 Anzahl Spalten und Reihen
# Zeige dir die Anzahl der Spalten und Reihen im Datensatz an
ncol(replication_data)
nrow(replication_data)


# 6.1.2 Relevante Variablen ansehen
# * Führe folgenden Code aus und untersuche die für uns relevanten Daten.
# * Beschreibe die Variablen ID, STAI, Pretest.High und Posttest.High anhand
#   der angezeigten Histogramme
replication_data %>% 
  select(ID, STAI, Pressure, Condition, 
         Pretest.High, Posttest.High) %>% 
  skim()


# 6.1.3 Variablen selektieren und Variablennamen reinigen
# * Selektiere die für uns relevanten Variablen mit select
# * Reinige die Variablennamen mit Hilfe der Funktion clean_names
# * Speichere den Datensatz in der Variable replication_data_subset
replication_data_subset <- replication_data %>% 
  select(ID, STAI, Pressure, Condition, 
         Pretest.High, Posttest.High) %>%
  clean_names()


# 6.1.4 Proband*innen zählen
# * Zähle wie viele Reihen es pro Proband*in gibt. 
# * Schaue dir die Daten der beiden Personen an, indem du den Datensatz
# um diese beiden Personen filterst
count(replication_data_subset, id)

replication_data_subset %>% 
  filter(id %in% c(1, 2))


# 6.1.5 Proband*innen entfernen
# * Entferne die Probanden, welche bei stai, pretest_high und
#   posttest_high 0-er Werte haben
# * Speichere den Datensatz in der Variable replication_data_subset_unique
# TODO: Ressource filter mit Operatoren
replication_data_subset_unique <- replication_data_subset %>% 
  filter(!((id %in% c(1, 2)) & pretest_high == 0 & posttest_high == 0))


# 6.2 Daten transformieren ------------------------------------------------

# 6.2.1 Daten in langes Format bringen
# Die Variablen `pretest_high` und `posttest_high` sind in einem
# sogenannten langen Format. Anstatt dieser Variablen könten wir auch
# eine mit dem Namen `test` und eine mit dem Namen `accuracy` haben. 
# Deine Aufgabe ist es, die Daten so zu transformieren, dass der Datensatz
# diese Struktur hat. Verwende hierfür pivot_longer
# Speichere den Datensatz in der Variable replication_data_long
replication_data_long <- replication_data_subset_unique %>% 
  pivot_longer(
    cols = contains("high"),
    names_to = "test",
    values_to = "accuracy"
  )


# 6.2.2 Test umschreiben
# Kodiere die Variable test folgendermaßen um:
# pretest_high -> Pretest
# posttest_high -> Posttest
replication_data_long <- replication_data_long %>% 
  mutate(
    test = case_when(
      test == "pretest_high" ~ "Pretest",
      test == "posttest_high" ~ "Posttest",
      TRUE ~ test
    )
  )

# 6.3 Daten exportieren -----------------------------------------------------

# 6.3.1 csv und sav speichern
# Speichere den Datensatzreplication_data_long  als CSV und SAV-Datei
# unter data/export mit dem Dateinamen replication_cleaned.csv
write_csv(replication_data_long, "data/export/replication_cleaned.csv")
write_sav(replication_data_long, "data/export/replication_cleaned.sav")
