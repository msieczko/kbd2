SET SQLBLANKLINES ON
ALTER TABLE KONTA 
DROP CONSTRAINT KONT_DARCZ_FK;

ALTER TABLE OPERACJE_BANKOWE 
DROP CONSTRAINT ID_KONTA_NADAWCY_FK;

ALTER TABLE OPERACJE_BANKOWE 
DROP CONSTRAINT ID_KONTA_ODBIORCY_FK;

ALTER TABLE OPERACJE_BANKOWE 
DROP CONSTRAINT OP_BANK_PODOP_FK;

ALTER TABLE OPERACJE_BANKOWE 
DROP CONSTRAINT OP_BANK_SL_KL_FK;

ALTER TABLE PODOPIECZNI 
DROP CONSTRAINT PODOP_KONT_FK;

ALTER TABLE SLOWA_KLUCZOWE 
DROP CONSTRAINT SL_KL_PODOP_FK;

DROP TABLE OPERACJE_BANKOWE;

DROP TABLE SLOWA_KLUCZOWE;

DROP TABLE PODOPIECZNI;

DROP TABLE KONTA;

DROP TABLE DARCZYNCY;

DROP SEQUENCE ID_SLOWA_KL_SEQ;

DROP SEQUENCE ID_PODOP_SEQ;

DROP SEQUENCE ID_OPER_BANK_SEQ;

DROP SEQUENCE ID_KONTA_SEQ;

DROP SEQUENCE ID_DARCZYNCY_SEQ;

CREATE TABLE DARCZYNCY 
(
  ID_DARCZYNCY NUMBER(8) NOT NULL 
, NAZWA VARCHAR2(200) NOT NULL 
, EMAIL VARCHAR2(254) 
, UWAGI VARCHAR2(1000) 
, CONSTRAINT DARCZYNCY_PK PRIMARY KEY 
  (
    ID_DARCZYNCY 
  )
  ENABLE 
);

CREATE TABLE KONTA 
(
  ID_KONTA NUMBER(6) NOT NULL 
, NR_KONTA VARCHAR2(26) NOT NULL 
, TYP_WLASCICIELA CHAR(1) NOT NULL 
, DATA_ZALOZENIA DATE 
, OPIS VARCHAR2(500) 
, ID_DARCZYNCY NUMBER(8) 
, CONSTRAINT KONT_PK PRIMARY KEY 
  (
    ID_KONTA 
  )
  USING INDEX 
  (
      CREATE UNIQUE INDEX KONT_PK_IDX ON KONTA (ID_KONTA ASC) 
  )
  ENABLE 
);

CREATE TABLE PODOPIECZNI 
(
  ID_PODOP NUMBER(4) NOT NULL 
, NAZWISKO VARCHAR2(40) NOT NULL 
, IMIE VARCHAR2(20) NOT NULL 
, STATUS CHAR(1) DEFAULT 'A' NOT NULL 
, ID_KONTA NUMBER(6) NOT NULL 
, EMAIL VARCHAR2(254) 
, UWAGI VARCHAR2(1000) 
, CONSTRAINT PODOP_PK PRIMARY KEY 
  (
    ID_PODOP 
  )
  USING INDEX 
  (
      CREATE UNIQUE INDEX PODOP_PK_IDX ON PODOPIECZNI (ID_PODOP ASC) 
  )
  ENABLE 
);

CREATE TABLE SLOWA_KLUCZOWE 
(
  ID_SLOWA_KL NUMBER(5, 0) NOT NULL 
, WARTOSC VARCHAR2(200) NOT NULL 
, OPIS VARCHAR2(500) 
, ID_PODOP NUMBER(4) NOT NULL 
, CONSTRAINT SL_KL_PK PRIMARY KEY 
  (
    ID_SLOWA_KL 
  )
  USING INDEX 
  (
      CREATE UNIQUE INDEX SL_KL_PK_IDX ON SLOWA_KLUCZOWE (ID_SLOWA_KL ASC) 
  )
  ENABLE 
);

CREATE TABLE OPERACJE_BANKOWE 
(
  ID_OPERACJI NUMBER(8) NOT NULL 
, KWOTA NUMBER(7, 2) NOT NULL 
, DATA_OPERACJI DATE NOT NULL 
, ID_KONTA_NADAWCY NUMBER(6) NOT NULL 
, ID_KONTA_ODBIORCY NUMBER(6) NOT NULL 
, ID_PODOP NUMBER(4)
, ID_SLOWA_KL NUMBER(5, 0) 
, TYTUL VARCHAR2(200) 
, UWAGI VARCHAR2(500) 
, CONSTRAINT OP_BANK_PK PRIMARY KEY 
  (
    ID_OPERACJI 
  )
  USING INDEX 
  (
      CREATE UNIQUE INDEX OP_BANK_PK_IDX ON OPERACJE_BANKOWE (ID_OPERACJI ASC) 
  )
  ENABLE 
);

CREATE INDEX KONT_DARCZ_FK_IDX ON KONTA (ID_DARCZYNCY);

CREATE INDEX ID_KONT_NAD_FK_IDX ON OPERACJE_BANKOWE (ID_KONTA_NADAWCY);

CREATE INDEX ID_KONT_ODB_FK_IDX ON OPERACJE_BANKOWE (ID_KONTA_ODBIORCY);

CREATE INDEX OP_BANK_PODOP_FK_IDX ON OPERACJE_BANKOWE (ID_PODOP);

CREATE INDEX OP_BANK_SL_KL_FK_IDX ON OPERACJE_BANKOWE (ID_SLOWA_KL);

CREATE INDEX PODOP_KONT_FK_IDX ON PODOPIECZNI (ID_KONTA);

CREATE INDEX SL_KL_PODOP_FK_IDX ON SLOWA_KLUCZOWE (ID_PODOP);

ALTER TABLE KONTA
ADD CONSTRAINT KONT_NR_KONTA_UK UNIQUE 
(
  NR_KONTA 
)
ENABLE;

ALTER TABLE PODOPIECZNI
ADD CONSTRAINT PODOP_EMAIL_UN UNIQUE 
(
  EMAIL 
)
USING INDEX 
(
    CREATE UNIQUE INDEX PODOP_EMAIL_UN_IDX ON PODOPIECZNI (EMAIL ASC) 
)
 ENABLE;

ALTER TABLE SLOWA_KLUCZOWE
ADD CONSTRAINT SL_KL_WART_UN UNIQUE 
(
  WARTOSC 
)
USING INDEX 
(
    CREATE UNIQUE INDEX SL_KL_WART_UN_IDX ON SLOWA_KLUCZOWE (WARTOSC ASC) 
)
 ENABLE;

ALTER TABLE KONTA
ADD CONSTRAINT KONT_DARCZ_FK FOREIGN KEY
(
  ID_DARCZYNCY 
)
REFERENCES DARCZYNCY
(
  ID_DARCZYNCY 
)
ENABLE;

ALTER TABLE OPERACJE_BANKOWE
ADD CONSTRAINT ID_KONTA_NADAWCY_FK FOREIGN KEY
(
  ID_KONTA_NADAWCY 
)
REFERENCES KONTA
(
  ID_KONTA 
)
ENABLE;

ALTER TABLE OPERACJE_BANKOWE
ADD CONSTRAINT ID_KONTA_ODBIORCY_FK FOREIGN KEY
(
  ID_KONTA_ODBIORCY 
)
REFERENCES KONTA
(
  ID_KONTA 
)
ENABLE;

ALTER TABLE OPERACJE_BANKOWE
ADD CONSTRAINT OP_BANK_PODOP_FK FOREIGN KEY
(
  ID_PODOP 
)
REFERENCES PODOPIECZNI
(
  ID_PODOP 
)
ENABLE;

ALTER TABLE OPERACJE_BANKOWE
ADD CONSTRAINT OP_BANK_SL_KL_FK FOREIGN KEY
(
  ID_SLOWA_KL 
)
REFERENCES SLOWA_KLUCZOWE
(
  ID_SLOWA_KL 
)
ENABLE;

ALTER TABLE PODOPIECZNI
ADD CONSTRAINT PODOP_KONT_FK FOREIGN KEY
(
  ID_KONTA 
)
REFERENCES KONTA
(
  ID_KONTA 
)
ENABLE;

ALTER TABLE SLOWA_KLUCZOWE
ADD CONSTRAINT SL_KL_PODOP_FK FOREIGN KEY
(
  ID_PODOP 
)
REFERENCES PODOPIECZNI
(
  ID_PODOP 
)
ENABLE;

ALTER TABLE KONTA
ADD CONSTRAINT KONT_DATA_ZAL_CK CHECK 
((TYP_WLASCICIELA = 'F' AND DATA_ZALOZENIA IS NOT NULL) OR (TYP_WLASCICIELA = 'D' AND DATA_ZALOZENIA IS NULL))
ENABLE;

ALTER TABLE KONTA
ADD CONSTRAINT KONT_ID_DARCZYNCY_CK CHECK 
((TYP_WLASCICIELA = 'F' AND ID_DARCZYNCY IS NULL) OR (TYP_WLASCICIELA = 'D' AND ID_DARCZYNCY IS NOT NULL))
ENABLE;

ALTER TABLE KONTA
ADD CONSTRAINT KONT_NR_KONTA_CK CHECK 
(REGEXP_LIKE(NR_KONTA, '^\d{26}$'))
ENABLE;

ALTER TABLE KONTA
ADD CONSTRAINT KONT_TYP_CK CHECK 
(TYP_WLASCICIELA IN ('F', 'D'))
ENABLE;

ALTER TABLE PODOPIECZNI
ADD CONSTRAINT PODOP_STAT_CK CHECK 
(STATUS IN ('A', 'N'))
ENABLE;

COMMENT ON TABLE DARCZYNCY IS 'Informacje o darczyncach - nadawcach przelewow z darowiznami. Jeden darczynca moze miec wiele kont z ktorych wplaca darowizny.';

COMMENT ON TABLE KONTA IS 'Informacje o kontach fundacji oraz wplacajacych darowizny. W przypadku konta fundacji - przypisani sa do niego podopieczni. W przypadku konta darczyncy - przypisany jest darczynca';

COMMENT ON TABLE OPERACJE_BANKOWE IS 'Informacje o darowiznach wplacanych na konta podopiecznych. Operacja moze zostac przypisana do podopiecznego na 2 sposoby. 
1) na podstawie slowa kluczowego - wtedy ID_SLOWA_KL wskazuje na uzyte slowo kluczowe a ID_PODOP wskazuje na podopiecznego. 
2) w wyniku recznego przypisania - wtedy ID_SLOWA_KL ma wartosc NULL a ID_PODOP wskazuje na podopiecznego. ';

COMMENT ON TABLE PODOPIECZNI IS 'Informacje o podopiecznym dla ktorego zbierane sa darowizny. Kazdy podopieczny ma przypisane konto na ktore trafiaja przeznaczone dla niego darowizny.';

COMMENT ON TABLE SLOWA_KLUCZOWE IS 'Slowa kluczowe pozwalajace dokonac automatycznego przypisania operacji bankowej do podopiecznego na podstawie jej tytulu.';

COMMENT ON COLUMN DARCZYNCY.ID_DARCZYNCY IS 'Klucz sztuczny.';

COMMENT ON COLUMN DARCZYNCY.NAZWA IS 'Przy automatycznym tworzeniu darczyncy uzupelniana na podstawie nazwy nadawcy przelewu. Maksymalnie 200 znakow.';

COMMENT ON COLUMN DARCZYNCY.EMAIL IS 'Email jest unikalny posrod wszystkich darczyncow w bazie danych.';

COMMENT ON COLUMN DARCZYNCY.UWAGI IS 'Maksymalnie 1000 znakow.';

COMMENT ON COLUMN KONTA.ID_KONTA IS 'Klucz sztuczny.';

COMMENT ON COLUMN KONTA.NR_KONTA IS 'Maksymalnie 26 cyfr. Numer rachunku bankowego bez spacji. Numery kont nie moga sie powtarzac.  ';

COMMENT ON COLUMN KONTA.TYP_WLASCICIELA IS 'Wartosc ''F'' (konto nalezace do fundacji - wplywaja na nie darowizny) albo ''D'' (konto nalezace do darczyncy).';

COMMENT ON COLUMN KONTA.DATA_ZALOZENIA IS 'Data zalozenia konta ktore nalezy do fundacji. Jesli konto nalezy do darczyny - wartosc NULL';

COMMENT ON COLUMN KONTA.OPIS IS 'Maksymalnie 500 znakow.';

COMMENT ON COLUMN KONTA.ID_DARCZYNCY IS 'Jesli konto nalezy do darczyncy - wskazanie na darczynce, w przeciwnym przypadku wartosc NULL';

COMMENT ON COLUMN OPERACJE_BANKOWE.ID_OPERACJI IS 'Klucz sztuczny.';

COMMENT ON COLUMN OPERACJE_BANKOWE.KWOTA IS 'Maksymalna kwota: 99999,99 z�.';

COMMENT ON COLUMN OPERACJE_BANKOWE.ID_KONTA_ODBIORCY IS 'Jeden z rachunkow fundacji na ktory zostala wplacona darowizna';

COMMENT ON COLUMN OPERACJE_BANKOWE.ID_PODOP IS 'Podopieczny do ktorego przypisana jest operacja.';

COMMENT ON COLUMN OPERACJE_BANKOWE.ID_SLOWA_KL IS 'Je�li operacja zostala przypisana do podopiecznego na podstawie slowa kluczowego to ID_SLOWA_KL wskazuje na to slowo kluczowe. Je�eli dokonano r�cznej modyfikacji przypisania operacji do podopiecznego, ID_SLOWA_KL ustawianie jest na NULL.';

COMMENT ON COLUMN OPERACJE_BANKOWE.TYTUL IS 'Maksymalnie 200 znakow.';

COMMENT ON COLUMN OPERACJE_BANKOWE.UWAGI IS 'Maksymalnie 500 znakow.';

COMMENT ON COLUMN PODOPIECZNI.ID_PODOP IS 'Klucz sztuczny.';

COMMENT ON COLUMN PODOPIECZNI.NAZWISKO IS 'Maksymalnie 40 znakow.';

COMMENT ON COLUMN PODOPIECZNI.IMIE IS 'Maksymalnie 20 znakow.';

COMMENT ON COLUMN PODOPIECZNI.STATUS IS 'Wartosc ''A'' (aktywny) lub ''N'' (nieaktywny).';

COMMENT ON COLUMN PODOPIECZNI.EMAIL IS 'Email podopiecznego; musi byc unikalny w ramach podopiecznych zarejestrowanych w bazie danych.';

COMMENT ON COLUMN PODOPIECZNI.UWAGI IS 'Opcjonalne, dodatkowe informacje. Maksymalnie 1000 znak�w.';

COMMENT ON COLUMN SLOWA_KLUCZOWE.ID_SLOWA_KL IS 'Klucz sztuczny.';

COMMENT ON COLUMN SLOWA_KLUCZOWE.WARTOSC IS 'Wartosc ktora szukana jest w tytule operacji. Maksymalnie 200 znakow.';

COMMENT ON COLUMN SLOWA_KLUCZOWE.OPIS IS 'Maksymalnie 500 znakow.';

COMMENT ON COLUMN SLOWA_KLUCZOWE.ID_PODOP IS 'Podopieczny do ktorego nalezy dane slowo kluczowe.';

CREATE SEQUENCE ID_DARCZYNCY_SEQ INCREMENT BY 1 START WITH 1 ORDER;

CREATE SEQUENCE ID_KONTA_SEQ INCREMENT BY 1 START WITH 1 ORDER;

CREATE SEQUENCE ID_OPER_BANK_SEQ INCREMENT BY 1 START WITH 1 ORDER;

CREATE SEQUENCE ID_PODOP_SEQ INCREMENT BY 1 START WITH 1 ORDER;

CREATE SEQUENCE ID_SLOWA_KL_SEQ INCREMENT BY 1 START WITH 1 ORDER;

CREATE OR REPLACE TRIGGER ID_DARCZYNCY_SEQ_TRG 
BEFORE INSERT ON DARCZYNCY
FOR EACH ROW WHEN (NEW.ID_DARCZYNCY IS NULL)
BEGIN
SELECT ID_DARCZYNCY_SEQ.NEXTVAL INTO :NEW.ID_DARCZYNCY FROM dual;
END;
/

CREATE OR REPLACE TRIGGER ID_KONTA_SEQ_TRG 
BEFORE INSERT ON KONTA
FOR EACH ROW WHEN (NEW.ID_KONTA IS NULL)
BEGIN
SELECT ID_KONTA_SEQ.NEXTVAL INTO :NEW.ID_KONTA FROM dual;
END;
/

CREATE OR REPLACE TRIGGER ID_OPER_BANK_SEQ_TRG 
BEFORE INSERT ON OPERACJE_BANKOWE
FOR EACH ROW WHEN (NEW.ID_OPERACJI IS NULL)
BEGIN
SELECT ID_OPER_BANK_SEQ.NEXTVAL INTO :NEW.ID_OPERACJI FROM dual;
END;
/

CREATE OR REPLACE TRIGGER ID_PODOP_SEQ_TRG 
BEFORE INSERT ON PODOPIECZNI 
FOR EACH ROW 
WHEN (NEW.ID_PODOP IS NULL) 
BEGIN
    SELECT ID_PODOP_SEQ.NEXTVAL INTO :NEW.ID_PODOP FROM SYS.DUAL;
END;
/

CREATE OR REPLACE TRIGGER ID_SLOWA_KL_SEQ_TRG 
BEFORE INSERT ON SLOWA_KLUCZOWE
FOR EACH ROW WHEN (NEW.ID_SLOWA_KL IS NULL)
BEGIN
SELECT ID_SLOWA_KL_SEQ.NEXTVAL INTO :NEW.ID_SLOWA_KL FROM dual;
END;
/