# Progetto-Reti-Logiche_2023-2024
Prova Finale - Progetto di Reti Logiche 2023/2024 - Politecnico di Milano

---

## Panoramica

Questo progetto è stato sviluppato come prova finale per il corso di **Reti Logiche** presso il **Politecnico di Milano**.  
L'obiettivo principale è stato l'implementazione di un componente hardware conforme a una specifica assegnata.



## Specifiche

### Descrizione Generale

Il modulo implementato presenta:
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

Il modulo interagisce con la memoria **RAM** per acquisire ed elaborare dati, seguendo il protocollo di comunicazione definito.


### Funzionamento

Quando riceve un segnale di **reset**, la macchina torna allo stato iniziale:
- `o_done = '0'` (elaborazione non ancora terminata).
- Tutti i valori di memoria vengono azzerati.

I dati in ingresso vengono ricevuti attraverso una sequenza di bit sul segnale **i_k**, il quale rappresenta il numero di parole W da elaborare.  
Le sequenze vengono lette dalla memoria a partire dall'indirizzo iniziale fornito in `i_add`, con una distanza di 2 byte tra una parola e la successiva.

#### Regole di elaborazione:
- Se viene trovato un valore **zero (0)** nella sequenza, questo viene **sostituito** con l'ultimo valore valido letto.
- Per ogni parola `W`, viene assegnato un valore di **credibilità C**:
  - `C = 31` se `W ≠ 0`
  - `C` viene decrementato di 1 se `W = 0`
  - Il valore di `C` non può scendere sotto `0`
  - `C` viene resettato a `31` quando viene incontrato un nuovo valore `W ≠ 0`
- Una volta completata l'elaborazione, i dati risultanti vengono **salvati in memoria**, alternando il valore `W` e il corrispondente valore `C`.

#### Vincoli temporali:
- L'elaborazione viene eseguita **entro 20 cicli di clock**.
- Il segnale `o_done` viene impostato a `1` per un solo ciclo di clock alla conclusione di ogni richiesta.
- Il segnale `i_start` rimane basso (`0`) fino alla successiva elaborazione.



## Implementazione

L'implementazione del modulo hardware è fornita nel seguente file **VHDL**:

📂 **Codice Implementazione**: `modulo_sequenza.vhd`

Per una documentazione completa del progetto, consulta il report:  
📄 **Documentazione**: [report.pdf](./report.pdf) *(da caricare nel repository!)*

---
