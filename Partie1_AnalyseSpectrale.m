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
% signal = -> compléter la ligne ci-dessous puis décommenter

x=(0:1:nech-1)';

signal=a0*sin(2*pi*x*f0/Fe);

% affichage du signal obtenu
figure('Name','Signal généré','NumberTitle','off');
plot(x,signal,"r-"); 
legend; grid;
title('Signal généré'); xlabel('Echantillons');

% -> changer la valeur de f0 en prenant 3266 Hertz, 1980 Hertz... pour voir la différence
%Plus la frequence est grande plus le signal devient plus oscillant
% figure('Name','Signal 3266Hz','NumberTitle','off');
% signal1=a0*sin(2*pi*x*3266/Fe);
% plot(x,signal1,"b-");
% figure('Name','Signal 1980','NumberTitle','off');
% signal2=a0*sin(2*pi*x*1980/Fe);
% plot(x,signal2,"g-");
% -> remettre ensuite la valeur initiale 123 Hertz
f0=123;
% génération d'un bruit blanc gaussien

b = zeros(size(x)); % initialisation du vecteur "bruit" de taille [nech x 1]

% on se fixe le rapport signal à bruit (SNR, en dB)
% on rappelle que SNR = 10 log10 (puissance signal / puissance bruit)
SNR = 20; % en dB,

% -> quelle est la valeur théorique de la puissance Ps du sinus
% réponse : (a0^2)/2;
Ps = [(a0^2)/2]

% -> vérifier sa valeur en calculant la puissance de x (on pourra utiliser la fonction "var")
Pstheorique = var(x)
% -> en déduire la puissance Pb du bruit en fonction du SNR et de Ps
Pb = Ps/(10^(SNR/10))

% -> générer le vecteur b de taille [nech x 1] constitué de réalisations d'un bruit blanc gaussien de puissance Pb
% Aide 1 : pour générer des variables aléatoire de loi normale/gaussienne, on utilisera la fonction "randn" (faire "help randn" pour comprendre son utilisation)
% Aide 2 : on rappelle que la puissance Ps d'un bruit blanc gaussien est égale à la variance du bruit
b=sqrt(Pb)*randn(size(x));
y = zeros(size(x)); % initialisation du vecteur "signal bruité" de taille [nech x 1]

% -> générer le sinus bruité (en fonction de x et b)
y = signal+b

% affichage du signal obtenu sur la même figure
hold on;
plot(y,'g-');
title(['Signal généré avec un SNR = ' num2str(SNR) ' dB']);
hold off

% -> changer la valeur du SNR : SNR = 50, 10, 5, 0, -5, -15 dB pour voir la différence
% Réponse : Plus que SNR augmente plus que le signal devient plus proche au
% sinus normal, et lorsque SNR diminue le signal ressemble plus à du bruit 
% en rajoutant dans la génération du signal une deuxième sinusoide de fréquence f1 = f0 + deltaf d'amplitude a1 = K*a0 
deltaf = 100;
f1 = f0 + deltaf;
K = 1/20;
a1 = K*a0;
signal_new = signal + a1*sin(2*pi*x*f1/Fe);
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
modcarre = (abs(fft(y,nfft)).^2);
Speriodo = 1/(nech) *modcarre;

% Pour afficher le résultat, il faut créer un vecteur "frequences" pour l'axe des abscisses, en travaillant en fréquences physiques (Hertz) ou en fréquences normalisées.

frequencesHertz = zeros(nfft,1); % initialisation du vecteur
frequencesNorm = zeros(nfft,1); % initialisation du vecteur

% -> définir les vecteurs des fréquences (axes des absicsses)
% aide on pourra utiliser la fonction linspace
frequencesHertz = linspace(0,Fe,nfft);
frequencesNorm  = linspace(0,1,nfft);
% Affichage
figure('Name','Périodogramme complet','NumberTitle','off');
subplot(2,1,1); plot(frequencesHertz,Speriodo); 
title('Périodogramme'); xlabel('Fréquences en Hertz');
subplot(2,1,2); plot(frequencesNorm,Speriodo); 
title('Périodogramme'); xlabel('Fréquences normalisées');

% -> vérifiez bien que le signal contient bien une fréquence pure à f0 fréquence de la partie sinusoïdale apparait au bon
% -> à quoi correspond l'autre fréquence ?
% réponse : le signal est réel
% -> pourquoi n'a-t-on pas une "raie" à cette fréquence ?
% réponse : on a utilisé une TFD donc il s'agit des fonctions sinus
% cardinal qui ne donnent pas des rails idéales
% -> que visualise-t-on ?
% réponse : la puissance du signal selon les fréquences

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
% on observe que les raies sont plus apparents lorsque 
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
% Rectangulaire
% - Forme : toutes les valeurs égales à 1
% - Leakage : élevé (on peut pas distinguer facilement les pics principaux)
% - Smearing : faible
% cette fenetre decroit rapidement donc il y a beacoup de fuites de
% puissance

% Bartlett
% Leakage : modéré puisque il y a une décroissance linéaire au bords
% Smearing : modéré 

% Hamming 
% faible leakage mais sa forme est similaire a celle de Hanning et ses
% bords sont pas aussi proches de zero et son smearing est petit peu plus
% large ce qui fait que ça reduit plus les pics secondaires comparé

% Blackman 
%Son leakage est très faible , son smearing s agit d un pic principal plus 
%large et sa forme cosinus à bords très atténués meilleure réduction des fuites, 
% mais le pic devient plus large









% -> les classer en fonction du phénomène de "leakage"
% [utiliser les lignes ci-dessous pour répondre]

%1. Rectangulaire       
% 2. Bartlett 
% 3. Hanning             
% 4. Hamming             
% 5. Blackman
%


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

% Relancer le programme en rajoutant dans la génération du signal une deuxième sinusoide de fréquence f1 = f0 + deltaf d'amplitude a1 = K*a0 
% (il sera sans doute préférable de modifier l'affichage pour afficher séparément les différents périodogrammes)
% Tester pour K=1 et deltaf = 8 Hertz puis 7, 6 et 3 Hertz
% -> intérpréter
% - lorsque deltaf est grand (8 Hz) : les deux pics sont bien apparentes.
% - lorsque deltaf est moyen (7-6 Hz) : les pics se rapprochent, la séparation moins nette.
% - lorsque deltaf est petit (3 Hz) : les deux pics se rassemble en un seul pic large.
% -> La fenêtre choisie a une influence sur la séparation : plus faible est le leakage meilleure est la distinction entre les pics
% , mais le pic principal reste plus large (smearing).
Sper_bar_new = (1/nech) * abs(fft(signal_new .* w_bar, nfft)).^2;
Sper_ham_new = (1/nech) * abs(fft(signal_new .* w_ham, nfft)).^2;
Sper_han_new = (1/nech) * abs(fft(signal_new .* w_han, nfft)).^2;
Sper_bla_new = (1/nech) * abs(fft(signal_new .* w_bla, nfft)).^2;
figure('Name','nouveaux Périodogrammes modifiés','NumberTitle','off');
subplot(2,1,1); plot(freq_mi,Speriodo_mi); hold on;
plot(freq_mi,Sper_bar_new(1:nfft_mi),'r');
plot(freq_mi,Sper_ham_new(1:nfft_mi),'g');
plot(freq_mi,Sper_han_new(1:nfft_mi),'m');
plot(freq_mi,Sper_bla_new(1:nfft_mi),'c');
legend('Per Rect','Per Bartlett','Per Hamming','Per Hanning','Per Blackman');
title('Périodogrammes modifiés (différentes fenêtres) en échelle linéaire'); xlabel('Fréquences normalisées');
subplot(2,1,2); plot(freq_mi,10*log10(Speriodo_mi)); hold on;
plot(freq_mi,10*log10(Sper_bar_new(1:nfft_mi)),'r');
plot(freq_mi,10*log10(Sper_ham_new(1:nfft_mi)),'g');
plot(freq_mi,10*log10(Sper_han_new(1:nfft_mi)),'m');
plot(freq_mi,10*log10(Sper_bla_new(1:nfft_mi)),'c');
title('Périodogrammes en dB'); xlabel('Fréquences normalisées');ylabel('dB');

% Tester pour deltaf = 100 Hertz et K=1/10, 1/20, 1/40, 1/100 pour SNR = 20 dB
% Avec deltaf = 100 Hz et K = 1/10, 1/20, 1/40, 1/100 : 
% - lorsque K est grand (1/10) : le deuxième pic devient visible.
% - lorsque K est moyen (1/20, 1/40) : le pic devient faible, compliquée à distinguer.
% - lorsque K est petit (1/100) : le pic disparaît dans le bruit.
% -> Plus K diminue, le deuxieme sinus devient moins distinguable . La
% fenetre influence le signal obtenu aussi.














% Fin Périodogramme modifié
% -------------------------

%% 3. Application sur un signal réel
% reprendre le programme en changeant le signal y par un signal réel charger le signal ventilateur_Fe_5120Hz.txt dans y
% Fe=5120 Hz
% en faire l'analyse spectrale par les divers estimateurs
% dans ce cas, il est mieux d'afficher les fréquences en Hz en abscisse
% que peut-on dire sur ce signal ?
% le fichier ventilateur_Fe_5120Hz.txt n'existe pas sur moodle donc on a
% pas pu faire le travail
%Le signal montre des pics à certaines fréquences correspondant aux rotations et vibrations du ventilateur.
% FIN du TP
% ----------------------------------------------------------------------