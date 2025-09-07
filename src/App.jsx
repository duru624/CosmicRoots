import { IonApp, IonPage, IonContent, IonButton, IonHeader, IonTitle, IonToolbar } from '@ionic/react';
import './App.css';
import '@ionic/react/css/core.css';


function App() {
  return (
    <IonApp>
      <IonPage>
        <IonHeader>
          <IonToolbar>
            <IonTitle>CosmicRoots 🌱</IonTitle>
          </IonToolbar>
        </IonHeader>

        <IonContent className="ion-padding">
          <h2>Hoşgeldiniz!!</h2>
          <IonButton expand="block" color="dark">
            Hadi Başlayalım
          </IonButton>
        </IonContent>
      </IonPage>
    </IonApp>
  );
}

export default App;
