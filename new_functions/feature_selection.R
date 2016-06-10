feature_selection <- function(features, groups,
                              forceToExclude = NULL,
                              forceToInclude = NULL,
                              FSdirections = c('forward','backward'),
                              CV_object){
    
# R imports ---------------------------------------------------------------
    require(spMisc)
    # `%>%` <- magrittr::'%>%'
    # 
#  ------------------------------------------------------------------------
    forceToExclude = NULL # požymiai, priverstinai įtraukiami į analizę;
    forceToInclude = NULL # požymiai, priverstinai pašalinami iš analizės;
    FSdirections = c('forward','backward')
#  ------------------------------------------------------------------------
    fIn  <-  paste(forceToInclude, collapse = ", ") %if_null_or_len0% "-"
    fOut <-  paste(forceToExclude, collapse = ", ") %if_null_or_len0% "-"
#  ------------------------------------------------------------------------
    data("Scores2", package = "spHelper")
#  ------------------------------------------------------------------------
    k_amp <- features <- Scores2[[]]
    gr <- groups <- Scores2$gr
#  ------------------------------------------------------------------------
    grNames <- levels(gr)
#  ------------------------------------------------------------------------

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
    FS_direction = FSdirections[direction_i]
    nKomp = ncol(k_amp) # % visų komponentų skaičius
    # % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # % visų naudosimų analizėje komponentų indeksų vektorius
    k_all = setdiff(1:nKomp, forceToExclude)

    switch (FS_direction,# % jau pasirinktų komponentų indeksų vektorius
        'forward'  = {k_in = forceToInclude}, # %tuščia arba tik "privalomi" požymiai
        'backward' = {k_in = k_all}          # % visi požymiai
    )

    info = data.frame()
    sprintf('Nuoseklus požymių atrinkimas kryptimi "%s". ', FS_direction)

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
        switch (FS_direction, # % testuosimų komponentų indeksų vektorius
            'forward' = {
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

           'backward' = {
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
            switch (FS_direction, #  % Analizuosimų komponentų pasirintikas
                'forward' = {
                    # % Jei yra privalomų komponentų, analizuojame tik juos
                    if (cycle == 1 & kIncluded) {
                        k_i = forceToInclude;
                    } else {
                        k_i = c(k_in, kToTest[i]) %>% sort # %pridedama po 1
                    }
                } ,

                'backward' = {
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
            
# ========================================================================
            # % Kriterijaus statistikų skaičiavimas
            # MATLAB
            # crit = [crit; cvfun(@klasif_DNT,k_amp_i, gr,cv,mcreps,ParOptions,k_i)];


            # NOT implemented in R yet
            crit_current_iteration <- cvfun(FUN = klasif_DNT,
                                            k_amp_i, gr,cv,mcreps,ParOptions,k_i)
# ========================================================================


            # Bind results of each iteration
            crit = rbind(crit, crit_current_iteration)

        }

        # % Geriausio (jei pridedama) ar prasčiausio (jei atmetama) komponentų
        # % rinkinio radimas pagal kriterijų ir pridėjimas/atmetimas
        #
        iMax = which.max(crit$mTPRtest)

        k_cur = kToTest[iMax];

        switch (FS_direction, #  % Analizuosimų komponentų pasirintikas
                'forward' = {
                    if (cycle == 1 & kIncluded){
                        k_add = NA;
                    } else {
                        k_add = k_cur;
                        k_in = c(k_in, k_add) %>% sort
                    }
                    k_rem = '-'
                } ,

                'backward' = {
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
        # %% Išvestis

        info_current <- data.frame('cycle' = cycle,
                              'forced_out' = fOut,
                              'forced_in'  = fIn,
                              'in_model'   = paste(k_in, collapse = ", "),
                              'added'      = k_add,
                              'removed'    = k_rem,
                              # ...
                              'st01_mTPR_mok'  = crit.st01_mTPRmok[iMax],
                              'st01_mTPR_test' = crit.st01_mTPRtest[iMax],
                              # ...
                              'TPR_random' = crit.pRand[1],
                              # ...
                              'mTPR_mok'    = crit.mTPRmok[iMax],
                              'CI_mTPR_mok' = crit.mCImok[iMax,],
                              # ...
                              'mTPR_test'    = crit.mTPRtest[iMax],
                              'CI_mTPR_test' = crit.mCItest[iMax,],
                              # ...
                              'nNeurons' = crit.nNeurons[1]
                              )

        info = rbind(info, info_current)

        rm(crit)
    }

    # Collect results the results
    t0_end <- Sys.time()
    DURATION = time_elapsed(t0_start,t0_end)

    info$Description = 'Sequential feature selection'
    info$Direction   = FS_direction

    info$Start       = sdate
    info$Duration    = DURATION

    info$Parameters  = Parameters


    # %% Rezultatų išsaugojimas
    save.image(file = "feature_selection_results(" %++% Sys.time() %++% ").RData")

}


}

