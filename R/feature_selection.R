feature_selection <- function(features, groups, forceToExclude, forceToInclude,
                              CV_object)

    # R imports ---------------------------------------------------------------
    `%>%` <- magrittr::'%>%'

#  ------------------------------------------------------------------------
data("Scores2", package = "spHelper")
#  ------------------------------------------------------------------------
k_amp <- features <- Scores2[[]]
gr <- groups <- Scores2$gr
#  ------------------------------------------------------------------------
grNames <- levels(gr)


#  ------------------------------------------------------------------------


forceToExclude = NULL # požymiai, priverstinai įtraukiami į analizę;
forceToInclude = NULL # požymiai, priverstinai pašalinami iš analizės;

fIn  <-  paste(forceToInclude, collapse = ", ") %if_null_or_len0% "-"
fOut <-  paste(forceToExclude, collapse = ", ") %if_null_or_len0% "-"

FSdirections = c('forward','backward')

# Not prepatred for R
# x = SpData.Properties.UserData.x;
# y = SpData.y_norm;
# ID = SpData.ID;


#  ------------------------------------------------------------------------

# Reikia CV_objekto


# %% Sukuriamas CV objektas
# if exist('ID', 'var')
# cv = cvpartitionID(gr,ID,cvType,nPartitions);
# disp('Skirstant į mokymo ir validavimo imtis SUBLOKUOJAMA pagal kintamąjį ID.')
# # % Funkcija 'cvpartitionID' duomenis su vienodu ID traktuoja kaip duomenų
# # % blokus ir vieną ploką priskiria arba tik mokymo arba tik testavimo
# # % imčiai.
# else
#     cv = cvpartition(gr,cvType,nPartitions);
#     warning('[!] Kintamasis ID nerastas.')
# end
#  ------------------------------------------------------------------------

cat(paste('>>> Included groups:', paste(grNames, collapse = ", "), '<<<\n'))

# Direction of selection -------------------------------------------------
#
# For direction (forward, backward)
#
# direction_i - i-th direction
# direction_i = 1
for (direction_i in 1:2){
    FSkryptis = FSdirections[direction_i]
    nKomp = ncol(k_amp) # % visų komponentų skaičius
    # % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # % visų naudosimų analizėje komponentų indeksų vektorius
    k_all = setdiff(1:nKomp, forceToExclude)

    switch (FSkryptis,# % jau pasirinktų komponentų indeksų vektorius
        'forward'  = {k_in = forceToInclude}, # %tuščia arba tik "privalomi" požymiai
        'backward' = {k_in = k_all}          # % visi požymiai
    )

    info = data.frame()
    sprintf('Nuoseklus požymių atrinkimas kryptimi "%s". ', FSkryptis)
    t0_start = Sys.time()

    # MATLAB:
    # kIncluded = ~isempty(forceToInclude);
    # nCycles = length(k_all) - length(forceToInclude) + kIncluded ;

    kIncluded = !is.null(forceToInclude)
    nCycles = length(k_all) - length(forceToInclude) + kIncluded

    # Ciklų skaičius -----------------------------------------------------------
    # % ciklo metu pridedamas arba pašalinamas 1 komponentas
    # cycle = 1
    for (cycle in 1:nCycles){

        # Describe the purpose of SWITCH sentence
        # .......
        # ......
        switch (FSkryptis, # % testuosimų komponentų indeksų vektorius
            'pridedama' = {
                # % Kai yra privalomų (forceToInclude) komponentų testuojamas pradinis
                 # % modelis be papldomų komponentų
                if (cycle == 1 & kIncluded) {
                    kToTest = forceToInclude
                    nIters = 1 # % tiriamas nurodytas modelis, todėl tik 1 iteracija

                } else {
                    kToTest = setdiff(k_all,k_in)
                    nIters = length(kToTest) # % iteracijų sk = testuosimų komponentų skaičius
               }
            },

           'atmetama' = {
                # % Pirmo ciklo metu arba kai yra privalomų (forceToInclude)
                if (cycle == 1){
                    kToTest = NA;
                    nIters = 1; # % tiriamas pradinis modelis, todėl tik 1 iteracija

                } else if (cycle == nCycles & kIncluded) {
                    kToTest = forceToInclude;
                    nIters = 1; # % tiriamas nurodytas modelis, todėl tik 1 iteracija

                } else {
                    kToTest = setdiff(k_in, forceToInclude)
                    nIters = length(kToTest)
                }
            }
        )
        crit = data.frame(); # % Vektoriaus su kriterijaus statistikomis "nunulinimas"
        #  Iteracija --------------------------------------------------------------
        # % Iteracijos metu tikrinamos visos kombinacijos su prieš tai buvusiu
        # % komponentų rinkiniu prie jo pridedant/atimant vieną papildomą komponentą
        for (i in 1:nIters){
            # % Informacija apie vykdomą analizę
            # fprintf(repmat('\b',1,s)); # % ištrinam, kas buvo parašyta
            # %         fprintf('\n')
            s = sprintf('Ciklas %g/%g, iteracija %g/%g ', cycle, nCycles,i,nIters);
            # %         fprintf('\n')
            switch (FSkryptis, #  % Analizuosimų komponentų pasirintikas
                'pridedama' = {
                    # % Jei yra privalomų komponentų, analizuojame tik juos
                    if (cycle == 1 & kIncluded) {
                        k_i = forceToInclude;
                    } else {
                        k_i = c(k_in, kToTest[i]) %>% sort # %pridedama po 1
                    }
                } ,

                'atmetama' = {
                    # % Pirmame cikle: nieko nekeičiama, tiriamas visas modelis
                    if (cycle == 1){
                        k_i = k_in
                        # % jei nurodyta, kad tam tikri požymiai privalo būt modelyje
                    } else if (cycle == nCycles & kIncluded) {
                        k_i = forceToInclude
                        # % Kituose cikluose atmetama po 1 požymį
                    } else {
                        k_i = setdiff(k_in, kToTest[i]) %>% sort
                    }
                }
            )
            # %  -----------------------------------------------------------------------
            k_amp_i = k_amp[ ,k_i]

            # % Kriterijaus statistikų skaičiavimas
            # MATLAB
            # crit = [crit; cvfun(@klasif_DNT,k_amp_i, gr,cv,mcreps,ParOptions,k_i)];

            # NOT implemented in R yet
            crit_current_iteration <- cvfun(FUN = klasif_DNT,
                                            k_amp_i, gr,cv,mcreps,ParOptions,k_i)

            # Bind results of each iteration
            crit = rbind(crit, crit_current_iteration)

        }

        # % Geriausio (jei pridedama) ar prasčiausio (jei atmetama) komponentų
        # % rinkinio radimas pagal kriterijų ir pridėjimas/atmetimas
        #
        iMax = which.max(crit$mTPRtest)

        k_cur = kToTest[iMax];

        switch (FSkryptis, #  % Analizuosimų komponentų pasirintikas
                'pridedama' = {
                    if (cycle == 1 & kIncluded){
                        k_add = NA;
                    } else {
                        k_add = k_cur;
                        k_in = c(k_in, k_add) %>% sort
                    }
                    k_rem = '-'
                } ,

                'atmetama' = {
                    if (cycle == nCycles & kIncluded){
                        k_rem = setdiff(k_in,forceToInclude);
                    } else {
                        k_rem = k_cur
                    }
                    k_add = '-';
                    k_in = setdiff(k_in, k_rem) %>% sort
                }
        )
        # % ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~





    }
}





