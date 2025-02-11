# Progetto-Reti-Logiche_2023-2024
Prova Finale - Progetto di Reti Logiche 2023/2024 - Politecnico di Milano

---

## Panoramica

Questo progetto è stato sviluppato come prova finale per il corso di **Reti Logiche** presso il **Politecnico di Milano**.  
L'obiettivo principale è stato l'implementazione di un componente hardware conforme a una specifica assegnata.



## Specifiche

### Descrizione Generale

Il modulo da realizzare include tre ingressi a 1 bit dedicati alla gestione dei segnali di clock, reset e start. Sono inoltre presenti due ingressi principali per i dati: un segnale a 8 bit (i_k) e uno a 16 bit (i_add). L’uscita fornisce un segnale a 1 bit (o_done) per indicare il completamento dell’elaborazione.

In aggiunta, il modulo comunica con una memoria RAM attraverso i seguenti segnali:
 - Due uscite a 1 bit: una per abilitare l’accesso alla RAM (in lettura e scrittura, o_mem_en) e una per la sola abilitazione in scrittura (o_mem_we).
 - Un’uscita a 16 bit (o_mem_addr) che specifica l’indirizzo di memoria da utilizzare.
 - Due porte dati a 8 bit: una in uscita (o_mem_data) e una in ingresso (i_mem_data), destinate allo scambio dei dati con la RAM.

- **Ingressi**:
  - `i_clk` (1 bit) – Segnale di clock.
  - `i_rst` (1 bit) – Reset asincrono.
  - `i_start` (1 bit) – Segnale di avvio.
  - `i_k` (8 bit) – Numero di parole da elaborare.
  - `i_add` (16 bit) – Indirizzo iniziale della sequenza in RAM.
- **Uscite**:
  - `o_done` (1 bit) – Indica la terminazione dell’elaborazione.
  - `o_mem_en` (1 bit) – Abilitazione della RAM (lettura/scrittura).
  - `o_mem_we` (1 bit) – Abilitazione della scrittura in RAM.
  - `o_mem_addr` (16 bit) – Indirizzo di memoria attuale.
  - `o_mem_data` (8 bit) – Dato da scrivere in RAM.
  - `i_mem_data` (8 bit) – Dato letto dalla RAM.


### Funzionamento

Il modulo accede a una sequenza di K parole W, memorizzata a partire da un indirizzo iniziale e distribuita ogni 2 byte consecutivi. Durante l’elaborazione, sostituisce ogni zero (W = 0) con l’ultimo valore valido precedentemente letto e attribuisce un valore di “credibilità” C al byte successivo. Questo valore C inizia da 31 e viene decrementato ogni volta che si incontra un dato mancante (W = 0), fino a un minimo di 0; poi, al primo valore non nullo della sequenza, torna nuovamente a 31.

Il modulo richiede tre segnali di ingresso fondamentali: un segnale di clock (i_clk), un reset asincrono (i_rst) e un segnale di avvio (i_start), insieme a due segnali dati (i_add a 16 bit e i_k a 10 bit). L’uscita principale è il segnale i_done, che indica il completamento dell’elaborazione. Il funzionamento del modulo è sincrono sul fronte di salita del clock, eccetto per il segnale di reset.

Durante l’inizializzazione, DONE viene impostato a 0, e l’elaborazione inizia solamente quando START è alto. START rimane a 1 fino al termine del processo, in cui viene innalzato il segnale DONE. Per accettare un secondo (o succeessivo) comando START, non è necessario che il modulo venga resettato.

## Implementazione

L'implementazione del modulo hardware è fornita nel seguente file **VHDL**:

📂 **Codice Implementazione**: `modulo_sequenza.vhd`

Per una documentazione completa del progetto, consulta il report:  
📄 **Documentazione**: [report.pdf](./Report.pdf)

---
