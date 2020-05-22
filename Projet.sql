--1
--Pour créer la table Genre
CREATE TABLE Genre (
	code CHAR(5),
	libelle varchar2(80) not null,

	CONSTRAINT pk_genre PRIMARY KEY (code)
) ;

--Pour créer la table Ouvrage
CREATE TABLE Ouvrage (
	isbn number(10), 
          titre varchar2(200)not null, 
          auteur varchar2(80),
          genre char(5) not null, 
          editeur varchar2(80),

	CONSTRAINT pk_ouvrage PRIMARY KEY (isbn),
	CONSTRAINT fk_ouvrage FOREIGN KEY (genre) REFERENCES Genre (code)
) ;

--Pour créer la table Exemplaire
CREATE TABLE Exemplaire (
	isbn number(10),
          numero number(3),
          etat char(5) 
                    constraint "etat validity"
                    check((etat is null) or (etat in ('NE', 'BO', 'MO', 'MA'))),

	CONSTRAINT pk_exemplaire PRIMARY KEY (isbn, numero),
	CONSTRAINT fk_exemplaire FOREIGN KEY (isbn) REFERENCES Ouvrage (isbn)
) ;

--Pour créer la table Membre
CREATE TABLE Membre (
	numero number(6),
          nom varchar2(80) not null, 
          prenom varchar2(80) not null,
          adresse varchar2(200) not null, 
          telephone char(10) not null,
          adhesion date not null,
          duree number(2) not null
                    constraint "duree validity"
                    check(duree > 0),
          
	CONSTRAINT pk_Membre PRIMARY KEY (numero)
) ;

--Pour créer la table Emprunt
CREATE TABLE Emprunt (
	numero number(10),
          membre number(6),
          creele date default sysdate,

	CONSTRAINT pk_emprunt PRIMARY KEY (numero),
	CONSTRAINT fk_emprunt FOREIGN KEY (membre) REFERENCES Membre (numero)
) ;

--Pour créer la table Detailsemprunt
CREATE TABLE Detailsemprunt (
	emprunt number(10) not null,
          numero number(3) not null,
          isbn number(10),
          exemplaire number(3),
          rendule date,

	CONSTRAINT fk1_detailsemprunt FOREIGN KEY (emprunt) REFERENCES Emprunt (numero),
          CONSTRAINT fk2_detailsemprunt FOREIGN KEY (isbn, exemplaire) REFERENCES Exemplaire (isbn,numero),
	CONSTRAINT pk_detailsemprunt PRIMARY KEY (emprunt, numero,isbn)
) ;

----------------------------------------
--2

--sequence pour la table Membre
CREATE SEQUENCE seq_membres START WITH 1;

--TRIGGER pour la table Membre
CREATE OR REPLACE TRIGGER generatecleprimairemembre
BEFORE INSERT ON Membre for each row
BEGIN
          SELECT seq_membres.NEXTVAL INTO :new.numero FROM Dual;
          EXCEPTION
          WHEN OTHERS THEN 
          NULL;
END; 

--Test
--INSERT INTO Membre(nom, prenom, adresse, telephone, adhesion, duree) VALUES('KHAMPHOUSONE','Thierry','La Terre', 'ALO', '30/03/2020', 1);
--INSERT INTO Membre(nom, prenom, adresse, telephone, adhesion, duree) VALUES('MARTIN','Diane','La Lune', 'ALO', '30/03/2020', 2);


----------------------------------------
--3

ALTER TABLE Detailsemprunt
DROP CONSTRAINT fk1_detailsemprunt; 

ALTER TABLE Detailsemprunt
ADD CONSTRAINT fk_details_emprunts FOREIGN KEY (emprunt) REFERENCES Emprunt (numero) on delete cascade; 


----------------------------------------
--4

--Remplissage Table Genre
INSERT INTO Genre(code, libelle) VALUES('REC', 'Récit');

--Remplissage Table Ouvrage
INSERT INTO Ouvrage(isbn, titre, auteur, genre, editeur) VALUES(2203314168, 'LEFRANC-L''ultimatum', 'Martin, Carin', 'BD', 'Casterman');

--Remplissage Table Membre
INSERT INTO MEMBRE (NOM, PRENOM, ADRESSE, TELEPHONE, ADHESION, DUREE) VALUES ('ALBERT','Anne','13 rue des alpes','0601020304',to_date('19/01/17', 'DD-MM-RRRR'),1);
INSERT INTO MEMBRE (NOM, PRENOM, ADRESSE, TELEPHONE, ADHESION, DUREE) VALUES ('BERNAUD','Barnabé','6 rue des bécasses','0602030105',to_date('10/03/17', 'DD-MM-RRRR'),3);
INSERT INTO MEMBRE (NOM, PRENOM, ADRESSE, TELEPHONE, ADHESION, DUREE) VALUES ('CUVARD','Camille','52 rue des cerisiers','0602010509',to_date('10/12/16', 'DD-MM-RRRR'),6);
INSERT INTO MEMBRE (NOM, PRENOM, ADRESSE, TELEPHONE, ADHESION, DUREE) VALUES ('DUPOND','Daniel','11 rue des daims','0610236515',to_date('13/07/16', 'DD-MM-RRRR'),12);
INSERT INTO MEMBRE (NOM, PRENOM, ADRESSE, TELEPHONE, ADHESION, DUREE) VALUES ('EVROUX','Eglantine','34 rue des elfes','0658963125',to_date('21/10/16', 'DD-MM-RRRR'),6);
INSERT INTO MEMBRE (NOM, PRENOM, ADRESSE, TELEPHONE, ADHESION, DUREE) VALUES ('FREGEON','Fernand','11 rue des Francs','0602036987',to_date('14/02/16', 'DD-MM-RRRRD'),6);
INSERT INTO MEMBRE (NOM, PRENOM, ADRESSE, TELEPHONE, ADHESION, DUREE) VALUES ('GORIT','Gaston','96 rue de la glacerie','0684235781',to_date('21/10/16', 'DD-MM-RRRR'),1);
INSERT INTO MEMBRE (NOM, PRENOM, ADRESSE, TELEPHONE, ADHESION, DUREE) VALUES ('HEVARD','Hector','12 rue haute','0608546578',to_date('13/07/16', 'DD-MM-RRRR'),12);
INSERT INTO MEMBRE (NOM, PRENOM, ADRESSE, TELEPHONE, ADHESION, DUREE) VALUES ('INGRAND','Irène','54 rue des iris','0605020409',to_date('29/01/17', 'DD-MM-RRRR'),12);
INSERT INTO MEMBRE (NOM, PRENOM, ADRESSE, TELEPHONE, ADHESION, DUREE) VALUES ('JUSTE','Julien','5 place des Jacobins','0603069876',to_date('10/12/16', 'DD-MM-RRRR'),6);


--Remplissage Table Exemplaire
INSERT INTO Exemplaire(isbn, numero, etat) VALUES(2203314168, 1, 'MO');

--Remplissage Table Emprunt
INSERT INTO Emprunt(numero, membre, creele) VALUES(1, 1, to_date('01/09/16', 'DD-MM-RRRR'));

--Remplissage Table Detailsemprunt
INSERT INTO Detailsemprunt(emprunt, numero, isbn, exemplaire, rendule) VALUES(1, 1, 2038704015, 1, to_date('06/09/16', 'DD-MM-RRRR'));

----------------------------------------
--5

INSERT INTO Ouvrage(isbn, titre, auteur, genre, editeur) VALUES(2080703234, 'Cinq semaines en ballon', 'Jules Verne', 'ROM', 'Flammarion');


----------------------------------------
--6

ALTER TABLE emprunt ADD(etat char(2) DEFAULT 'EC');


----------------------------------------
--7

ALTER TABLE Emprunt add constraint ck_emprunts_etat check (etat in ('EC','RE')); 


----------------------------------------
--8

UPDATE Emprunt e
SET etat = 'RE'
WHERE EXISTS (SELECT NULL FROM Detailsemprunt d WHERE e.numero = d.emprunt AND d.rendule is not null);

----------------------------------------
--9

INSERT INTO Detailsemprunt(emprunt, numero, isbn, exemplaire, rendule) VALUES(7,2,2038704015,1,sysdate-136);  
INSERT INTO Detailsemprunt(emprunt, numero, isbn, exemplaire, rendule) VALUES(8,2,2038704015,1,sysdate-127);  
INSERT INTO Detailsemprunt(emprunt, numero, isbn, exemplaire, rendule) VALUES(11,2,2038704015,1,sysdate-95);  
INSERT INTO Detailsemprunt(emprunt, numero, isbn, exemplaire, rendule) VALUES(15,2,2038704015,1,sysdate-54);  
INSERT INTO Detailsemprunt(emprunt, numero, isbn, exemplaire, rendule) VALUES(16,3,2038704015,1,sysdate-43);
INSERT INTO Detailsemprunt(emprunt, numero, isbn, exemplaire, rendule) VALUES(17,2,2038704015,1,sysdate-36);   
INSERT INTO Detailsemprunt(emprunt, numero, isbn, exemplaire, rendule) VALUES(18,2,2038704015,1,sysdate-24);  
INSERT INTO Detailsemprunt(emprunt, numero, isbn, exemplaire, rendule) VALUES(19,2,2038704015,1,sysdate-13);   
INSERT INTO Detailsemprunt(emprunt, numero, isbn, exemplaire, rendule) VALUES(20,3,2038704015,1,sysdate-3); 


----------------------------------------
--10

UPDATE Exemplaire
SET etat = 'NE'
WHERE (numero = 1 AND isbn = 2038704015); 

----------------------------------------
--11

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER  updateExemplaire
BEFORE INSERT ON Detailsemprunt 
FOR EACH ROW

BEGIN
          
          DECLARE
          count_etat NUMBER(3);
          CURSOR iterateurExemplaire IS (SELECT etat, isbn, numero FROM Exemplaire); 
          var_etat CHAR(5);

          BEGIN
                    FOR i IN iterateurExemplaire
                    LOOP
                              SELECT count(*) INTO count_etat FROM Detailsemprunt WHERE i.isbn = isbn AND i.numero=exemplaire;
                              
                              IF count_etat <=10 THEN
                                        var_etat := 'NE';
                             ELSIF count_etat between 11 and 25 THEN
                                        var_etat := 'BO';
                              ELSIF count_etat between 26 and 40 THEN
                                         var_etat := 'MO';
                              ELSIF count_etat >= 41 THEN
                                        var_etat := 'MA';
                              END IF;
                              
                              UPDATE Exemplaire
                              SET etat = var_etat
                              WHERE(i.isbn = isbn and i.numero=numero);
                    END LOOP;
           END;
END;

---------------------------------------- 
--12

ALTER TABLE MEMBRE ADD(finAdhesion date as (ADD_MONTHS(adhesion,duree)));
--Ajout d'une colonne finAdhesion dans la table Membre qui calcule la data d'adhesion + la duree en mois. 


----------------------------------------
--13

CREATE OR REPLACE FUNCTION fct_finValidite(v_num NUMBER) Return DATE IS
BEGIN
        DECLARE
          var_finAdhesion DATE;
          
        BEGIN
                SELECT (finAdhesion - 14)  into var_finAdhesion
                FROM Membre
                WHERE numero = v_num;
                
                Return(var_finAdhesion);
        END;
END; 

SELECT fct_finValidite(1) FROM dual; --Commande a executer pour avoir le resultat de la fonction.


---------------------------------------- 
--14 

CREATE OR REPLACE FUNCTION fct_mesureActivite (v_duree NUMBER) Return NUMBER IS
BEGIN
        DECLARE
        numero_membre NUMBER; -- Le membre qui possède le plus d'emprunts 
        save_num_j NUMBER; --numero de membre courant
        
        cpt_k NUMBER;
        save_j NUMBER;
        save_i NUMBER;
        
        date_tmp_max DATE;
        date_tmp_min DATE;
        
        
        CURSOR iterateurMembre IS (SELECT numero FROM Membre); 
        CURSOR iterateurEmprunt IS (SELECT membre, creele FROM Emprunt);
        CURSOR iterateurEmprunt2 IS (SELECT membre, creele FROM Emprunt);

        BEGIN
                  cpt_k := 0;
                  save_j :=0;
                  save_i :=0;
          
                  FOR i IN iterateurMembre --pour chaque membre i
                  LOOP
                              FOR j IN iterateurEmprunt --intervalle de date
                              LOOP
                                         IF j.membre = i.numero THEN --condition car la table n'est pas dans l'ordre ! donc j avance mais membre de la table Emprunt n'est pas croissant !
                                                  date_tmp_min :=j.creele;
                                                  date_tmp_max :=ADD_MONTHS(j.creele, v_duree);
                                                            FOR k IN iterateurEmprunt2 
                                                            LOOP 
                                                                      IF ((k.creele >= date_tmp_min AND k.creele <= date_tmp_max) AND k.membre = i.numero) THEN
                                                                                cpt_k:= cpt_k+1;
                                                                      END IF;
                                                            END LOOP;
                                                            IF cpt_k > save_j  THEN
                                                                      save_j := cpt_k;  -- pour 1 j on garde le meilleur k et save_j est le plus grand nombre d'emprunt 
                                                                      save_num_j := j.membre; --on recupere le meilleur membre courant
                                                            END IF;
                                                                      cpt_k := 0;
                                        END IF;
                              END LOOP;    
                              IF save_j > save_i THEN
                                        save_i := save_j;
                                        numero_membre := save_num_j; --on recupere le gagnant
                              END IF;
                    END LOOP;      
                Return(numero_membre);
        END;
END; 

SELECT fct_mesureActivite(2)FROM DUAL;

---------------------------------------- 
--15

CREATE SEQUENCE seq_emprunt
START WITH 21
INCREMENT BY 1;
--DROP SEQUENCE seq_emprunt
--SELECT seq_emprunt.nextval from dual

--TRIGGER pour la table Emprunt
CREATE OR REPLACE TRIGGER gencleprimaireemprunt
BEFORE INSERT ON Emprunt for each row

BEGIN
          SELECT seq_emprunt.NEXTVAL INTO :new.numero FROM Dual;
          EXCEPTION
          WHEN OTHERS THEN 
          NULL;
END; 

--Procedure
CREATE OR REPLACE PROCEDURE proc_empruntExpress (e_isbn NUMBER, e_numero NUMBER, m_numero NUMBER)   AS
BEGIN
        DECLARE
                var_numero_emprunt NUMBER;
                var_isbn NUMBER;
                var_exemplaire NUMBER;
                tupleEmprunt Emprunt%rowtype; 
                
        BEGIN
                INSERT INTO Emprunt(membre)
                VALUES(m_numero); 
                
                SELECT NUMERO, MEMBRE, CREELE, ETAT  INTO tupleEmprunt FROM Emprunt WHERE membre=m_numero AND creele = sysdate;
                var_numero_emprunt := tupleEmprunt.numero;
                
                
                INSERT INTO DetailsEmprunt(emprunt, numero, isbn, exemplaire)
                VALUES(var_numero_emprunt, m_numero, e_isbn, e_numero); 
        END;
END;

--test
exec proc_empruntExpress(2253006327,1,1);

---------------------------------------- 
--16


CREATE OR REPLACE FUNCTION fct_nbOuvNonRendus (v_id NUMBER) Return NUMBER IS
BEGIN
        DECLARE
        nb_nonRendu NUMBER;
        
        BEGIN
                    SELECT count(*) INTO nb_nonRendu FROM DetailsEmprunt WHERE numero = v_id AND rendule IS NULL;
                    RETURN(nb_nonRendu);
        END;
END;

--test
SELECT fct_nbOuvNonRendus (1) FROM DUAL;


---------------------------------------- 
--17

SET SERVEROUTPUT ON;
--TRIGGER pour la table Emprunt
CREATE OR REPLACE TRIGGER verifemprunt 
BEFORE INSERT ON Emprunt for each row

BEGIN
          DECLARE
                    tmp DATE;
                    mon_erreur EXCEPTION;
                    PRAGMA EXCEPTION_INIT (mon_erreur, -20001);
          
          BEGIN
                    SELECT m.finadhesion INTO tmp FROM Membre m WHERE m.numero = :NEW.Membre;
                    DBMS_OUTPUT.PUT_LINE(tmp);
          
                    IF tmp < sysdate THEN 
                    RAISE mon_erreur; 
                    
                    END IF;
                    EXCEPTION
                    WHEN mon_erreur THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Date d''adhesion depassee');
                      
                    WHEN OTHERS THEN 
                    NULL;
          END;         
END; 

--ne fonctionne pas car trigger, délais d'abonnement périmé 
exec proc_empruntExpress(2253010219,1,1); 

 --test pour le membre KHAMPHOUSONE Thierry, fonctionne car abonnement récent et valide
INSERT INTO Membre(nom, prenom, adresse, telephone, adhesion, duree) 
VALUES('KHAMPHOUSONE','Thierry','La Terre', '000000000', '28/04/2020', 1); 
exec proc_empruntExpress(2070367177,3,21);  --21 : à remplacer par le numéro du membre ajouté correspondant à KHAMPHOUSONE Thierry

---------------------------------------- 
--18 

SET SERVEROUTPUT ON;
--TRIGGER pour la table Emprunt
CREATE OR REPLACE TRIGGER changementEmprunt
BEFORE UPDATE OF membre 
ON Emprunt for each row

BEGIN
          DECLARE
                    tmp_membre NUMBER(6);
                    mon_erreur2 EXCEPTION;
                    PRAGMA EXCEPTION_INIT (mon_erreur2, -20002);
          BEGIN
                    RAISE mon_erreur2; 
                    EXCEPTION
                    WHEN mon_erreur2 THEN
                    RAISE_APPLICATION_ERROR(-20002, 'Vous ne pouvez pas modifier le membre');
                    WHEN OTHERS THEN 
                    NULL;
          END;         
END; 

--test
-- Ceci fonctionne
UPDATE Emprunt e
SET e.etat = 'RE'
WHERE(e.numero = 1);  

-- Ceci ne fonctionnera pas car il va déclencher le trigger, le membre ne peut pas etre mis à jour.
UPDATE Emprunt e
SET e.etat = 'RE', e.membre = 1
WHERE(e.numero = 1);  


---------------------------------------- 
--19

--non fonctionnel ici, nous avons réécris 2 triggers pour remplacer celui ci. 

SET SERVEROUTPUT ON;
--TRIGGER pour la table Emprunt
CREATE OR REPLACE TRIGGER twoEventTrigger
BEFORE INSERT OR UPDATE ON( Exemplaire, DetailsEmprunt)
BEGIN
          DECLARE
                    nb_emprunt_nouveau NUMBER(3);
                    nb_emprunt_ancien NUMBER(3) ;
                    var_etat_nouveau CHAR(5);
                    var_etat_ancien CHAR(5);
                    mon_erreur3 EXCEPTION; 
                    PRAGMA EXCEPTION_INIT (mon_erreur3, -20003);
          
          BEGIN
                   IF inserting THEN 
                              BEGIN
                                        IF (:NEW.etat is null)
                                        THEN    
                                                  RAISE_APPLICATION_ERROR(-20003, 'Vous devez définir l''état de l''exemplaire.'); 
                                        EXCEPTION
                                        WHEN OTHERS THEN 
                                        NULL;
                                        END if;
                              END;
                    --il faut compter le nombre d'emprunt* 
                    ELSIF updating THEN 
                              BEGIN
                                        SELECT count(*) INTO nb_emprunt_nouveau FROM DetailsEmprunt WHERE exemplaire = :NEW.exemplaire;
                                        SELECT count(*) INTO nb_emprunt_ancien FROM DetailsEmprunt WHERE exemplaire = :OLD.exemplaire;
                                        
                                         nb_emprunt_nouveau =  nb_emprunt_nouveau+1;
                                          nb_emprunt_ancien =  nb_emprunt_ancien -1;
                                                                
                                        IF nb_emprunt_nouveau <=10 THEN
                                                  var_etat_nouveau := 'NE';
                                       ELSIF nb_emprunt_nouveau between 11 and 25 THEN
                                                  var_etat_nouveau := 'BO';
                                        ELSIF nb_emprunt_nouveau between 26 and 40 THEN
                                                   var_etat_nouveau := 'MO';
                                        ELSIF nb_emprunt_nouveau >= 41 THEN
                                                  var_etat_nouveau := 'MA';
                                        END IF;
                                        
                                        UPDATE DetailsEmprunt
                                        SET etat = var_etat_nouveau
                                        WHERE numero = :NEW.exemplaire;
                                        
                                        --
                                        
                                        IF  nb_emprunt_ancien <=10 THEN
                                                  var_etat_ancien := 'NE';
                                       ELSIF  nb_emprunt_ancien between 11 and 25 THEN
                                                 var_etat_ancien := 'BO';
                                        ELSIF nb_emprunt_ancien between 26 and 40 THEN
                                                   var_etat_ancien := 'MO';
                                        ELSIF  nb_emprunt_ancien >= 41 THEN
                                                  var_etat_ancien := 'MA';
                                        END IF;
                                        
                                        UPDATE DetailsEmprunt
                                        SET etat = var_etat_ancien
                                        WHERE numero = :OLD.exemplaire;
                               END; 
                    END IF; 
          END;   
END;

------trigger 1

SET SERVEROUTPUT ON;
--TRIGGER pour la table Emprunt
CREATE OR REPLACE TRIGGER FirstEventTrigger
BEFORE INSERT ON Exemplaire
for each row
BEGIN
          DECLARE
                    mon_erreur3 EXCEPTION; 
                    PRAGMA EXCEPTION_INIT (mon_erreur3, -20003);
          
          BEGIN
                    IF (:NEW.etat is null)
                    THEN    
                              RAISE_APPLICATION_ERROR(-20003, 'Vous devez définir l''état de l''exemplaire.'); 
                    END if;
                    EXCEPTION
                    WHEN OTHERS THEN 
                    NULL;
          END;   
END;

----- trigger 2


SET SERVEROUTPUT ON;
--TRIGGER pour la table Emprunt
CREATE OR REPLACE TRIGGER SecondEventTrigger 
BEFORE UPDATE ON DetailsEmprunt
for each row
BEGIN
          DECLARE
                    nb_emprunt_nouveau NUMBER(3);
                    nb_emprunt_ancien NUMBER(3) ;
                    var_etat_nouveau CHAR(5);
                    var_etat_ancien CHAR(5);
                    
          BEGIN
         
                    SELECT count(*) INTO nb_emprunt_nouveau FROM DetailsEmprunt WHERE exemplaire = (:NEW.exemplaire);
                    SELECT count(*) INTO nb_emprunt_ancien FROM DetailsEmprunt WHERE exemplaire = (:OLD.exemplaire);
                    
                     nb_emprunt_nouveau :=  nb_emprunt_nouveau+1; 
                      nb_emprunt_ancien :=  nb_emprunt_ancien -1; 
                                            
                    IF nb_emprunt_nouveau <=10 THEN
                              var_etat_nouveau := 'NE';
                   ELSIF nb_emprunt_nouveau between 11 and 25 THEN
                              var_etat_nouveau := 'BO';
                    ELSIF nb_emprunt_nouveau between 26 and 40 THEN
                               var_etat_nouveau := 'MO';
                    ELSIF nb_emprunt_nouveau >= 41 THEN
                              var_etat_nouveau := 'MA';
                    END IF;
                    
                    UPDATE Exemplaire
                    SET etat = var_etat_nouveau 
                    WHERE numero = :NEW.exemplaire AND isbn = :NEW.isbn;
                    
                    --
                    
                    IF  nb_emprunt_ancien <=10 THEN
                              var_etat_ancien := 'NE';
                   ELSIF  nb_emprunt_ancien between 11 and 25 THEN
                             var_etat_ancien := 'BO';
                    ELSIF nb_emprunt_ancien between 26 and 40 THEN
                               var_etat_ancien := 'MO';
                    ELSIF  nb_emprunt_ancien >= 41 THEN
                              var_etat_ancien := 'MA';
                    END IF;
                    
                    UPDATE Exemplaire
                    SET etat = var_etat_ancien
                    WHERE numero = :OLD.exemplaire AND isbn = :OLD.isbn;
          END;   
END;