DROP TABLE ARCGIS_EXTENT;
DROP TABLE ARCGIS_SPATIAL_REFERENCE;
DROP TABLE ARCGIS_LAYER;
DROP TABLE ARCGIS_SERVICE;
DROP TABLE ARCGIS_SERVER;

DROP SEQUENCE ARCGIS_EXTENT_PKSEQ;
DROP SEQUENCE ARCGIS_SPATIAL_REFERENCE_PKSEQ;
DROP SEQUENCE ARCGIS_LAYER_PKSEQ;
DROP SEQUENCE ARCGIS_SERVER_PKSEQ;
DROP SEQUENCE ARCGIS_SERVICE_PKSEQ;

-- ARCGIS_SERVER --
CREATE TABLE ARCGIS_SERVER (
    SERVER_ID NUMERIC PRIMARY KEY
    ,SERVER_URL VARCHAR(2083)
    ,SERVER_VERSION NUMBER(4,2)
    ,SERVER_RANK NUMBER(3,0)
    ,SERVER_SOURCE VARCHAR(64)
    ,NUM_OF_HIT NUMBER
    ,SCANNED_DT TIMESTAMP
    ,DISABLED NUMBER(1,0) DEFAULT 0
);
/
CREATE SEQUENCE ARCGIS_SERVER_PKSEQ START WITH 1 NOCACHE;
/
CREATE OR REPLACE TRIGGER ARCGIS_SERVER_PKTRIG
BEFORE INSERT ON ARCGIS_SERVER
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :NEW.SERVER_ID IS NULL THEN
            SELECT ARCGIS_SERVER_PKSEQ.NEXTVAL INTO :NEW.SERVER_ID FROM DUAL;
        END IF;
    END IF;
END;
/

-- ARCGIS_SERVICE --
CREATE TABLE ARCGIS_SERVICE(
    SERVICE_ID NUMERIC PRIMARY KEY
    ,SERVER_ID REFERENCES ARCGIS_SERVER(SERVER_ID) DISABLE
    ,"SERVICE_NAME" VARCHAR(160)
    ,"SERVICE_TYPE" VARCHAR(64)
    ,"SERVICE_DESCRIPTION" VARCHAR(4000)
    ,"SERVICE_URL" VARCHAR(2083)
    ,"DOCINFO_TITLE" VARCHAR(64)
    ,"DOCINFO_AUTHOR" VARCHAR(64)
    ,"DOCINFO_COMMENTS" VARCHAR(4000)
    ,"DOCINFO_SUBJECT" VARCHAR(400)
    ,"DOCINFO_CATEGORY" VARCHAR(64)
    ,"DOCINFO_KEYWORDS" VARCHAR(1000)
    ,SERVICE_RANK NUMBER(3,0)
    ,NUM_OF_HIT NUMBER
    ,SCANNED_DT TIMESTAMP
    ,DISABLED NUMBER(1,0) DEFAULT 0
);
/
CREATE SEQUENCE ARCGIS_SERVICE_PKSEQ START WITH 1 NOCACHE;
/
CREATE OR REPLACE TRIGGER ARCGIS_SERVICE_PKTRIG
BEFORE INSERT ON ARCGIS_SERVICE
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :NEW.SERVICE_ID IS NULL THEN
            SELECT ARCGIS_SERVICE_PKSEQ.NEXTVAL INTO :NEW.SERVICE_ID FROM DUAL;
        END IF;
    END IF;
END;
/

-- ARCGIS_LAYER --
CREATE TABLE ARCGIS_LAYER(
    METADATA_ID NUMERIC PRIMARY KEY
    ,SERVICE_ID REFERENCES ARCGIS_SERVICE(SERVICE_ID) DISABLE
    ,LAYER_ID NUMBER(3,0)
    ,"LAYER_NAME" VARCHAR(160)
    ,"LAYER_TYPE" VARCHAR(64)
    ,"LAYER_URL" VARCHAR(2083)
    ,"DESCRIPTION" VARCHAR(4000)
    ,"GEOMETRY_TYPE" VARCHAR(64)
    ,"DISPLAY_FIELD" VARCHAR(64)
    ,"KEYWORDS" VARCHAR(1000)
    ,"IMAGE" BLOB
    ,LAYER_RANK NUMBER(3,0)
    ,NUM_OF_HIT NUMBER
    ,SCANNED_DT TIMESTAMP
    ,DISABLED NUMBER(1,0) DEFAULT 0
);
/
CREATE SEQUENCE ARCGIS_LAYER_PKSEQ START WITH 1 NOCACHE;
/
CREATE OR REPLACE TRIGGER ARCGIS_LAYER_PKTRIG
BEFORE INSERT
ON ARCGIS_LAYER
FOR EACH ROW
BEGIN  
  IF INSERTING THEN
    IF :NEW.METADATA_ID IS NULL THEN 
      SELECT ARCGIS_LAYER_PKSEQ.NEXTVAL INTO :NEW.METADATA_ID FROM DUAL;
    END IF;
  END IF;
END;
/

-- ARCGIS_SPATIAL_REFERENCE --
CREATE TABLE ARCGIS_SPATIAL_REFERENCE(
    SPATIAL_REFERENCE_KEY NUMERIC PRIMARY KEY
    ,WKID NUMBER(6,0)
    ,LATEST_WKID NUMBER(6,0)
    ,WKT CLOB
);
/
CREATE SEQUENCE ARCGIS_SPATIAL_REFERENCE_PKSEQ START WITH 1 NOCACHE;
/
CREATE OR REPLACE TRIGGER ARCGIS_SPATIAL_REF_TRIGGER
BEFORE INSERT
ON ARCGIS_SPATIAL_REFERENCE
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :NEW.SPATIAL_REFERENCE_KEY IS NULL THEN
            SELECT ARCGIS_SPATIAL_REFERENCE_PKSEQ.NEXTVAL INTO :NEW.SPATIAL_REFERENCE_KEY FROM DUAL;
        END IF;
    END IF;
END;
/

-- ARCGIS_EXTENT --
CREATE TABLE ARCGIS_EXTENT(
    EXTENT_ID NUMERIC PRIMARY KEY
    ,X_MIN NUMBER
    ,Y_MIN NUMBER
    ,X_MAX NUMBER
    ,Y_MAX NUMBER
    ,METADATA_ID REFERENCES ARCGIS_LAYER(METADATA_ID) DISABLE
    ,SPATIAL_REFERENCE_KEY REFERENCES ARCGIS_SPATIAL_REFERENCE(SPATIAL_REFERENCE_KEY) DISABLE
);
/
CREATE SEQUENCE ARCGIS_EXTENT_PKSEQ START WITH 1 NOCACHE;
/
CREATE OR REPLACE TRIGGER ARCGIS_EXTENT_PKTRIG
BEFORE INSERT
ON ARCGIS_EXTENT
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :NEW.EXTENT_ID IS NULL THEN
            SELECT ARCGIS_EXTENT_PKSEQ.NEXTVAL INTO :NEW.EXTENT_ID FROM DUAL;
        END IF;
    END IF;
END;
/