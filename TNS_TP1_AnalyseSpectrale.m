%% TP TNS - Partie 1 - Analyse Spectrale
% -----------------------------------------------------
% Le texte du TP est directement écrit en commentaire
% But du TP : faire l'analyse spectrale d'un sinus + bruit en testant les différents paramètres des méthodes
% -----------------------------------------------------
% Le texte du TP est repéré par % en début de ligne
% certaines lignes du programme sont déjà écrites, d'autres restent à écrire
%
% Les variables sont systématiquement initialisées.
%
% Pour exécuter le programme dans ses versions qui vont évoluer au fil du TP, on peut sélectionner la partie du programme que l'on veut tester et faire F9 ou inclure des "pause;"

clear all; close all; clc;

%% 1- Génération du Signal à analyser
% -----------------------------------
% Génération d'un signal sinusoidal d'amplitude a0, de fréquence f0, échantilloné à la fréquence Fe sur nech échantillons

f0 = 123; % fréquence du sinus : 123 Hertz
a0 = 4; % amplitude du sinus
Fe = 8000; % fréquence d'échantillonnage : 8 kHz
nech = 1000; % nombre de points générés du signal

% génération du signal
x = zeros(nech,1); % initialisation du vecteur "signal" de taille [nech x 1]
% -> compléter la ligne ci-dessous puis décommenter
% x = [à compléter puis décommenter]

% affichage du signal obtenu
figure('Name','Signal généré','NumberTitle','off');
plot(x); 
title('Signal généré'); xlabel('Echantillons');

% -> changer la valeur de f0 en prenant 3266 Hertz, 1980 Hertz... pour voir la différence
% -> remettre ensuite la valeur initiale 123 Hertz

% génération d'un bruit blanc gaussien

b = zeros(size(x)); % initialisation du vecteur "bruit" de taille [nech x 1]

% on se fixe le rapport signal à bruit (SNR, en dB)
% on rappelle que SNR = 10 log10 (puissance signal / puissance bruit)
SNR = 20; % en dB,

% -> quelle est la valeur théorique de la puissance Ps du sinus
% réponse : [à compléter + en déduire la ligne ci-dessous]
% Ps = [à compléter puis décommenter]

% -> vérifier sa valeur en calculant la puissance de x (on pourra utiliser la fonction "var")

% -> en déduire la puissance Pb du bruit en fonction du SNR et de Ps
% Pb = [à compléter puis décommenter]

% -> générer le vecteur b de taille [nech x 1] constitué de réalisations d'un bruit blanc gaussien de puissance Pb
% Aide 1 : pour générer des variables aléatoire de loi normale/gaussienne, on utilisera la fonction "randn" (faire "help randn" pour comprendre son utilisation)
% Aide 2 : on rappelle que la puissance Ps d'un bruit blanc gaussien est égale à la variance du bruit
% b = [à compléter puis décommenter]

y = zeros(size(x)); % initialisation du vecteur "signal bruité" de taille [nech x 1]

% -> générer le sinus bruité (en fonction de x et b)
% y = [à compléter puis décommenter]

% affichage du signal obtenu sur la même figure
hold on;
plot(y,'r');
title(['Signal généré avec un SNR = ' num2str(SNR) ' dB']);
hold off

% -> changer la valeur du SNR : SNR = 50, 10, 5, 0, -5, -15 dB pour voir la différence

% Fin de génération du Signal à analyser
% -----------------------------------

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
% Speriodo = [à compléter puis décommenter]

% Pour afficher le résultat, il faut créer un vecteur "frequences" pour l'axe des abscisses, en travaillant en fréquences physiques (Hertz) ou en fréquences normalisées.

frequencesHertz = zeros(nfft,1); % initialisation du vecteur
frequencesNorm = zeros(nfft,1); % initialisation du vecteur

% -> définir les vecteurs des fréquences (axes des absicsses)
% aide on pourra utiliser la fonction linspace
% frequencesHertz = [à compléter puis décommenter]
% frequencesNorm  = [à compléter puis décommenter]

% Affichage
figure('Name','Périodogramme complet','NumberTitle','off');
subplot(2,1,1); plot(frequencesHertz,Speriodo); 
title('Périodogramme'); xlabel('Fréquences en Hertz');
subplot(2,1,2); plot(frequencesNorm,Speriodo); 
title('Périodogramme'); xlabel('Fréquences normalisées');

% -> vérifiez bien que le signal contient bien une fréquence pure à f0 fréquence de la partie sinusoïdale apparait au bon
% -> à quoi correspond l'autre fréquence ?
% réponse : [à compléter]
% -> pourquoi n'a-t-on pas une "raie" à cette fréquence ?
% réponse : [à compléter]
% -> que visualise-t-on ?
% réponse : [à compléter]

% comme le signal analysé est réel, on veut afficher le périodogramme qu'entre 0 et Fe/2
nfft_mi = nfft/2 + 1; % taille du vecteur à visualiser
freq_mi = frequencesNorm(1:nfft_mi); % vecteur fréquences normalisées de 0 à 0.5
Speriodo_mi = Speriodo(1:nfft_mi); % vecteur périodogramme de 0 à 0.5

% pour amliorer la visualisation, on veut afficher ce périodogramme en  échelle log pour percevoir les petits détails cachés... (en dB, ie 10 log10 () )
figure('Name','Périodogramme','NumberTitle','off');
subplot(2,1,1); plot(freq_mi,Speriodo_mi); 
title('Périodogramme en échelle linéaire'); xlabel('Fréquences normalisées');
subplot(2,1,2); plot(freq_mi,10*log10(Speriodo_mi)); 
title('Périodogramme en dB'); xlabel('Fréquences normalisées');ylabel('dB');

% Relancer le programme pour différents SNR
% SNR = 50, 10, 5, 0, -5, -15 dB pour voir la différence
% Fin Périodogramme
% -----------------

% 2.2. Périodogramme modifié
% --------------------------
% Rappel de la définition : 
% 1/nombre de points de signal * (module carré de la TFD du ( signal x fenêtre de pondération ))
% Ces fenêtres ont pour objectif d'arrondir la coupure et de produire des effets différents
% faire "help window" pour voir la liste des fenêtres déjà disponbibles dans Matlab.
% On se contentera de tester les fenêtres suivantes :  rectangulaire (ou
% naturelle), Bartlett (triangulaire), Hamming, Hanning, et Blackman

% -> sous Matlab, lancer wintool pour visualiser toutes ces fenêtres
% -> donner leurs principales propriétés/caractéristiques : phénomène de "leakage", phénomène de "smearing"
% [utiliser les lignes ci-dessous pour répondre]
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
% -> les classer en fonction du phénomène de "leakage"
% [utiliser les lignes ci-dessous pour répondre]
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

% initialisation des vecteurs périodogrammes modifiés
% remarque : pour la fenêtre rectangulaire, c'est le périodogramme précédemment calculé
Sper_bar = zeros(nfft,1); % fenêtre de Bartlett
Sper_ham = zeros(nfft,1); % fenêtre de Hamming
Sper_han = zeros(nfft,1); % fenêtre de Hanning
Sper_bla = zeros(nfft,1); % fenêtre de Blackman

% -> calculer les périodogrammes modifiés pour chaque fenêtre
% Sper_bar = [à compléter puis décommenter]
% Sper_ham = [à compléter puis décommenter]
% Sper_han = [à compléter puis décommenter]
% Sper_bla = [à compléter puis décommenter]

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

% Relancer le programme en rajoutant dans la génération du signal une deuxième sinusoide de fréquence f1 = f0 + deltaf d'amplitude a1 = K*a0 
% (il sera sans doute préférable de modifier l'affichage pour afficher séparément les différents périodogrammes)
% Tester pour K=1 et deltaf = 8 Hertz puis 7, 6 et 3 Hertz
% -> intérpréter
% [utiliser les lignes ci-dessous pour répondre]
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


% Tester pour deltaf = 100 Hertz et K=1/10, 1/20, 1/40, 1/100 pour SNR = 20 dB
% [utiliser les lignes ci-dessous pour répondre]
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




% Fin Périodogramme modifié
% -------------------------

%% 3. Application sur un signal réel
% reprendre le programme en changeant le signal y par un signal réel charger le signal ventilateur_Fe_5120Hz.txt dans y
% Fe=5120 Hz
% en faire l'analyse spectrale par les divers estimateurs
% dans ce cas, il est mieux d'afficher les fréquences en Hz en abscisse
% que peut-on dire sur ce signal ?
% FIN du TP
% ----------------------------------------------------------------------