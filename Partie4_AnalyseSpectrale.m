%% TP TNS - Partie 3 - Analyse spectrale et filtrage d'un signal réel
% -----------------------------------------------------
% Le texte du TP est directement écrit en commentaire
% But du TP : 
%   - faire l'analyse spectrale d'un signal réel
%   - filtrer ce signal r el
%   - faire l'analyse spectrale du signal filtré
% -----------------------------------------------------
% Le texte du TP est repéré par % en début de ligne
% certaines lignes du programme sont déjà écrites, d'autres restent à écrire
%
% Les variables sont systématiquement initialisées.
%
% Pour exécuter le programme dans ses versions qui vont évoluer au fil du TP, on peut sélectionner la partie du programme que l'on veut tester et faire F9 ou inclure des "pause;"

clear all; close all; clc;

%% 1- Chargement du signal réel
% ---------------------------------------------------

load('ventilateur_Fe_5120Hz.txt');
y = ventilateur_Fe_5120Hz;
nech = length(y);
Fe = 5120;
Te = 1/Fe;

figure('Name','Signal réel','NumberTitle','On');
x_sec = linspace(0,Te*nech,nech);
plot(x_sec,y); 
xlabel('Temps (s)');
title('Signal réel')

% Fin de chargement du signal réel
% -----------------------------------

%% 2 - Analyse spectrale du signal réel
% ---------------------------------------------------

% -> compléter ci-dessous pour réaliser l'analyse spectrale du signal réel
% Aide : vous pouvez vous appuyer sur le fichier TNS_TP1_AnalyseSpectrale.m que vous avez compléter pendant la 1ière séance
%% 2 - Analyse Spectrale
% 2.1 - Périodogramme
% -------------------
% Rappel de la définition : 
% 1/nombre de points de signal * (module au carré de la TFD du signal)
% la TFD est réalisée par la fonction "FFT" (faire "help fft" pour étudier tous ses paramètres)
% penser à faire du zero-padding !

% facteur de zero-padding
% si = 1, on fait du zero-padding jusqu'à la puissance de 2 supérieure
% si = 2, jusqu'à 2 * puissance de 2 supérieure,
% si = 3, jusqu'à 4 * puissance de 2 supérieure etc...
fact_zeropadding = 3;

% nombre de point de calcul après zero padding
nfft = 2^nextpow2(nech)*2^(fact_zeropadding-1);

Speriodo = zeros(nfft,1); % initialisation du vecteur "Périodogramme"

% -> calculer le périodogramme
modcarre = (abs(fft(y,nfft)).^2);
Speriodo = 1/(nech) *modcarre;

% Pour afficher le résultat, il faut créer un vecteur "frequences" pour l'axe des abscisses, en travaillant en fréquences physiques (Hertz) ou en fréquences normalisées.

frequencesHertz = zeros(nfft,1); % initialisation du vecteur
frequencesNorm = zeros(nfft,1); % initialisation du vecteur

% -> définir les vecteurs des fréquences (axes des absicsses)
frequencesHertz = linspace(0,Fe,nfft);
frequencesNorm  = linspace(0,1,nfft);
% Affichage
figure('Name','Périodogramme complet','NumberTitle','off');
subplot(2,1,1); plot(frequencesHertz,Speriodo); 
title('Périodogramme'); xlabel('Fréquences en Hertz');
subplot(2,1,2); plot(frequencesNorm,Speriodo); 
title('Périodogramme'); xlabel('Fréquences normalisées');


nfft_mi = nfft/2 + 1; % taille du vecteur à visualiser
freq_mi = frequencesNorm(1:nfft_mi); % vecteur fréquences normalisées de 0 à 0.5
Speriodo_mi = Speriodo(1:nfft_mi); % vecteur périodogramme de 0 à 0.5

% pour amliorer la visualisation, on veut afficher ce périodogramme en  échelle log pour percevoir les petits détails cachés... (en dB, ie 10 log10 () )
figure('Name','Périodogramme','NumberTitle','off');
subplot(2,1,1); plot(freq_mi,Speriodo_mi); 
title('Périodogramme en échelle linéaire'); xlabel('Fréquences normalisées');
subplot(2,1,2); plot(freq_mi,10*log10(Speriodo_mi)); 
title('Périodogramme en dB'); xlabel('Fréquences normalisées');ylabel('dB');
% initialisation des vecteurs périodogrammes modifiés
% remarque : pour la fenêtre rectangulaire, c'est le périodogramme précédemment calculé
Sper_bar = zeros(nfft,1); % fenêtre de Bartlett
Sper_ham = zeros(nfft,1); % fenêtre de Hamming
Sper_han = zeros(nfft,1); % fenêtre de Hanning
Sper_bla = zeros(nfft,1); % fenêtre de Blackman

% -> calculer les périodogrammes modifiés pour chaque fenêtre
w_bar = bartlett(nech); 
Sper_bar = (1/nech) * abs(fft(y .* w_bar, nfft)).^2;
w_ham = hamming(nech);
Sper_ham = (1/nech) * abs(fft(y .* w_ham, nfft)).^2;
w_han = hanning(nech);
Sper_han = (1/nech) * abs(fft(y .* w_han, nfft)).^2;
w_bla = blackman(nech);
Sper_bla = (1/nech) * abs(fft(y .* w_bla, nfft)).^2;

% affichage
figure('Name','Périodogrammes modifiés','NumberTitle','off');
subplot(2,1,1); plot(freq_mi,Speriodo_mi); hold on;
plot(freq_mi,Sper_bar(1:nfft_mi),'r');
plot(freq_mi,Sper_ham(1:nfft_mi),'g');
plot(freq_mi,Sper_han(1:nfft_mi),'m');
plot(freq_mi,Sper_bla(1:nfft_mi),'c');
legend('Per Rect','Per Bartlett','Per Hamming','Per Hanning','Per Blackman');
title('Périodogrammes modifiés (différentes fenêtres) en échelle linéaire'); xlabel('Fréquences normalisées');
subplot(2,1,2); plot(freq_mi,10*log10(Speriodo_mi)); hold on;
plot(freq_mi,10*log10(Sper_bar(1:nfft_mi)),'r');
plot(freq_mi,10*log10(Sper_ham(1:nfft_mi)),'g');
plot(freq_mi,10*log10(Sper_han(1:nfft_mi)),'m');
plot(freq_mi,10*log10(Sper_bla(1:nfft_mi)),'c');
title('Périodogrammes en dB'); xlabel('Fréquences normalisées');ylabel('dB');
















% -> interpréter : que voit-on ?
% [utiliser les lignes ci-dessous pour répondre]
% on voit à l'aide d'un facteur de zero-padding de 3 qu'il existe une seule
% fréquence qui prédomine les autres. Et puisque elle est assez basse (l'ordre de 0.01 approximativement 50 Hz) on va
% utiliser donc un filtre passe-haut, de fréquence de coupure fc = 20*50 = 1000Hz 
%
%
%
%
%
%
%
%
%
%
%
%
%


% Fin de l'analyse spectrale du signal réel
% ---------------------------------------------------

%% 3 - Filtrage du signal réel
% ---------------------------------------------------
% L'ojectif est de filtré le signal à l'aide d'un filtre conçu grâce au logiciel filtnum.m
% Les coefficients de ce filtre sont sauvegardés dans un fichier coefs.mat

% chargement des coefficients si le fichier existe (sinon chargement d'un filtre par défaut
if exist('coefs.mat', 'file')
    tmp = load('coefs.mat');
    a = tmp.a;
    b = tmp.b;
else
    a = 1;
    b = [-0.09   -0.1    0.90   -0.1   -0.09];
end

% -> définir l'ordre du filtre
% M = 5; % initialisation de l'ordre du filtre
M = length(b); %pou avoir suffisamment d'attenuation

% -> définir la réponse impulsionnelle (RI)
% RI = randn(1,M); % initialisation de la RI
RI = b;

x_sec_ri = linspace(0,Te*M,M);

figure
plot(x_sec_ri,RI)
xlabel('Temps (s)');
title('Réponse impulsionnelle')
FT= fft(RI) %calcul de la fonction de transfert
figure
%tracer la fonction de transfert en module et en phase en fonction de la fréquence
plot(x_sec_ri,abs(FT),'r-')
title("Module de la fonction de transfert")
figure
plot(x_sec_ri,phase(FT),'b-')
title("phase de la fonction de transfert")
y_filt = zeros(nech,1); % initialisation du vecteur "signal filtré"

% -> filtrer le signal
% Aide : on utilisera la fonction "filter" (faire "help filter" pour comprendre son utilisation)
y_filt = filter(b,a,y);
figure
hold on
plot(x_sec,y_filt,'r')

% Fin de chargement du signal réel
% -----------------------------------

%% 3 - Analyse spectrale du signal filtré
% ---------------------------------------------------

% -> compléter ci-dessous pour réaliser l'analyse spectrale du signal filtré
% en vous appuyant sur le fichier TNS_TP1_AnalyseSpectrale.m que vous avez compléter pendant la 1ière séance

% 2.1 - Périodogramme
% -------------------
% Rappel de la définition : 
% 1/nombre de points de signal * (module au carré de la TFD du signal)
% la TFD est réalisée par la fonction "FFT" (faire "help fft" pour étudier tous ses paramètres)
% penser à faire du zero-padding !

% facteur de zero-padding
% si = 1, on fait du zero-padding jusqu'à la puissance de 2 supérieure
% si = 2, jusqu'à 2 * puissance de 2 supérieure,
% si = 3, jusqu'à 4 * puissance de 2 supérieure etc...
fact_zeropadding = 3;

% nombre de point de calcul après zero padding
nfft = 2^nextpow2(nech)*2^(fact_zeropadding-1);

Speriodo = zeros(nfft,1); % initialisation du vecteur "Périodogramme"

% -> calculer le périodogramme
modcarre = (abs(fft(y,nfft)).^2);
Speriodo = 1/(nech) *modcarre;

% Pour afficher le résultat, il faut créer un vecteur "frequences" pour l'axe des abscisses, en travaillant en fréquences physiques (Hertz) ou en fréquences normalisées.

frequencesHertz = zeros(nfft,1); % initialisation du vecteur
frequencesNorm = zeros(nfft,1); % initialisation du vecteur

% -> définir les vecteurs des fréquences (axes des absicsses)
frequencesHertz = linspace(0,Fe,nfft);
frequencesNorm  = linspace(0,1,nfft);
% Affichage
figure('Name','Périodogramme complet','NumberTitle','off');
subplot(2,1,1); plot(frequencesHertz,Speriodo); 
title('Périodogramme'); xlabel('Fréquences en Hertz');
subplot(2,1,2); plot(frequencesNorm,Speriodo); 
title('Périodogramme'); xlabel('Fréquences normalisées');


nfft_mi = nfft/2 + 1; % taille du vecteur à visualiser
freq_mi = frequencesNorm(1:nfft_mi); % vecteur fréquences normalisées de 0 à 0.5
Speriodo_mi = Speriodo(1:nfft_mi); % vecteur périodogramme de 0 à 0.5

% pour amliorer la visualisation, on veut afficher ce périodogramme en  échelle log pour percevoir les petits détails cachés... (en dB, ie 10 log10 () )
figure('Name','Périodogramme','NumberTitle','off');
subplot(2,1,1); plot(freq_mi,Speriodo_mi); 
title('Périodogramme en échelle linéaire'); xlabel('Fréquences normalisées');
subplot(2,1,2); plot(freq_mi,10*log10(Speriodo_mi)); 
title('Périodogramme en dB'); xlabel('Fréquences normalisées');ylabel('dB');
% initialisation des vecteurs périodogrammes modifiés
% remarque : pour la fenêtre rectangulaire, c'est le périodogramme précédemment calculé
Sper_bar = zeros(nfft,1); % fenêtre de Bartlett
Sper_ham = zeros(nfft,1); % fenêtre de Hamming
Sper_han = zeros(nfft,1); % fenêtre de Hanning
Sper_bla = zeros(nfft,1); % fenêtre de Blackman

% -> calculer les périodogrammes modifiés pour chaque fenêtre
w_bar = bartlett(nech); 
Sper_bar = (1/nech) * abs(fft( y_filt.* w_bar, nfft)).^2;
w_ham = hamming(nech);
Sper_ham = (1/nech) * abs(fft(y_filt .* w_ham, nfft)).^2;
w_han = hanning(nech);
Sper_han = (1/nech) * abs(fft(y_filt .* w_han, nfft)).^2;
w_bla = blackman(nech);
Sper_bla = (1/nech) * abs(fft(y_filt .* w_bla, nfft)).^2;

% affichage
figure('Name','Périodogrammes modifiés','NumberTitle','off');
subplot(2,1,1); plot(freq_mi,Speriodo_mi); hold on;
% plot(freq_mi,Sper_bar(1:nfft_mi),'r');
plot(freq_mi,Sper_ham(1:nfft_mi),'g');
% plot(freq_mi,Sper_han(1:nfft_mi),'m');
% plot(freq_mi,Sper_bla(1:nfft_mi),'c');
legend('Per Rect','Per Hamming');
title('(différentes fenêtres) en échelle linéaire'); xlabel('Fréquences normalisées');
subplot(2,1,2); plot(freq_mi,10*log10(Speriodo_mi)); hold on;
% plot(freq_mi,10*log10(Sper_bar(1:nfft_mi)),'r');
plot(freq_mi,10*log10(Sper_ham(1:nfft_mi)),'g');
% plot(freq_mi,10*log10(Sper_han(1:nfft_mi)),'m');
% plot(freq_mi,10*log10(Sper_bla(1:nfft_mi)),'c');
title('Périodogrammes en dB'); xlabel('Fréquences normalisées');ylabel('dB');

% -> interpréter : que voit-on ?
% [utiliser les lignes ci-dessous pour répondre]
% on voit qu'il existe toujours un pic lié au régime transitoire du filtre
% on peut aussi visualiser ce pic a l'aide de l'interface filtnum en
% visualisant une reponse impulsionelle
%ainsi pour la fenetres de hamming les fréquences non disérables donc on
%respecte le gabarit qu'on a choisi

% Fin de l'analyse spectrale du signal filtré
% ---------------------------------------------------