# Mobile Computing 2020-2021

Repository destinata a contenere il progetto di Mobile Computing, anno accademico 2020-2021.

I collaboratori del progetto sono i componenti del gruppo di lavoro che svolgerà il progetto stesso, di seguito i nomi:
Luca Giuseppe Rocco, Matteo Romeo, Gianmarco Urbinati, Alessio Verticchio

# Tecnologie
## Server-Side
- Spring Boot
- Spring Data
- DB Relazionale MYSQL

## Client-Side
- Flutter
- Cognito Auth
- Cloudinary

# Come sono state usate le tecnologie
La parte server é in esecuzione su [Heroku](https://www.heroku.com/) e il servizio di autenticazione é [Cognito](https://aws.amazon.com/it/cognito/). Cognito, dopo il login fornisce un JWT Token che il server é capace di interpretare per recuperare i dati dell'utente dal DB. Sul DB non vengono persistite password.

Il DB é un MySQL in hosting su AWS con il servzio [AWS RDS](https://aws.amazon.com/it/rds/?trkCampaign=acq_paid_search_brand&sc_channel=ps&sc_campaign=acquisition_EMEA&sc_publisher=Google&sc_category=Database&sc_country=EMEA&sc_geo=EMEA&sc_outcome=acq&sc_detail=amazon%20mysql%20database&sc_content={adgroup}&sc_matchtype=e&sc_segment=467752181985&sc_medium=ACQ-P|PS-GO|Brand|Desktop|SU|Database|Solution|EMEA|EN|Sitelink|xx|EU&ef_id=Cj0KCQiAmL-ABhDFARIsAKywVaeBiNGcGU5FV0b7nGqxbWZEcqW24inXUkzh03LTkrgGUkNgfR857GYaAv1REALw_wcB:G:s&s_kwcid=AL!4422!3!467752181985!e!!g!!amazon%20mysql%20database).
Per le immagini del profilo viene usato [Cloudinary](https://cloudinary.com/), un servizi che fornisce delle API per caricare, modificare e cancellare delle immagini.
