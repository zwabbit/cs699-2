;Each row seems to be 1351 units wide. Starting at 105,500 (y,x), 142462
extensions [matrix]

breed [birds bird]

birds-own [energy lifetime]

patches-own
[
  landcover
  canopy2k1
  house1996
  house2k5
  frontage
  lakesize
  road soil
  ownership
  zoning
  mean_diam
  bin_list ;list of trees based on diameter
  dist_type ;0 if normal, 1 if neg exp
  herb_veg
  bug_pop
  b_area
  tree_height ;list of heights based on diameter
  volume ;list of volume based on diameter
  total_volume ;list of total volume per diameter
  cut-off
  cord ;pole timber
  mbf ;saw timber
  money_pole
  money_saw
  bird-range
]

globals [
  currentyear_saw
  total_saw
  currentyear_pole
  total_pole
  
  current_profit
  total_profit
  
  decid_matrix
  evergreen_matrix
  mixed_matrix
  wet_matrix
  
  decid_ingrow
  evergreen_ingrow
  mixed_ingrow
  wet_ingrow
  
  water-color
  ice-color
  dev-op-color
  dev-low-color
  dev-med-color
  dev-hi-color
  barren-color
  forest-dec-color
  forest-ever-color
  forest-mix-color
  shrub-color
  shrub-dwarf-color
  herb-grass-color
  herb-sed-color
  herb-lic-color
  herb-moss-color
  plant-past-color
  plant-crop-color
  wet-woody-color
  wet-emerg-color
  
  water
  ice
  dev-op
  dev-low
  dev-med
  dev-hi
  barren
  forest-dec
  forest-ever
  forest-mix
  shrub
  shrub-dwarf
  herb-grass
  herb-sed
  herb-lic
  herb-moss
  plant-past
  plant-crop
  wet-woody
  wet-emerg
  s-constant
  
  max_ba_41
  min_ba_41
  max_ba_42
  min_ba_42
  max_ba_43
  min_ba_43
  max_ba_90
  min_ba_90
]

to setup
  clear-patches
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  __clear-all-and-reset-ticks
  reset-ticks
  set water-color 105
  set ice-color 9.9
  set dev-op-color 137
  set dev-low-color 134
  set dev-med-color 15
  set dev-hi-color 13
  set barren-color 38
  set forest-dec-color 57
  set forest-ever-color 53
  set forest-mix-color 58
  set shrub-color 27
  set shrub-dwarf-color 25
  set herb-grass-color 47
  set herb-sed-color 44
  set herb-lic-color 43
  set herb-moss-color 85
  set plant-past-color 45
  set plant-crop-color 22
  set wet-woody-color 87
  set wet-emerg-color 94
  
  set water 11
  set ice 12
  set dev-op 21
  set dev-low 22
  set dev-med 23
  set dev-hi 24
  set barren 31
  set forest-dec 41
  set forest-ever 42
  set forest-mix 43
  set shrub-dwarf 51
  set shrub 52
  set herb-grass 71
  set herb-sed 72
  set herb-lic 73
  set herb-moss 74
  set plant-past 81
  set plant-crop 82
  set wet-woody 90
  set wet-emerg 95
  
  set s-constant 80
  
  set total_profit 0
  set current_profit 0
  set current_profit 0
  
  set total_pole 0
  set total_saw 0
  set currentyear_saw 0
  set currentyear_pole 0
  
  file-open user-file
  repeat 142462
  [
    let lineone file-read-line
  ]
  repeat 100
  [
    repeat 100
    [
      let id file-read
      ;print id
      let skip1 file-read-characters 1
      ;print skip1
      let row file-read - 155
      let skip2 file-read-characters 1
      let col file-read - 551
      ;ask patch col row [ set pcolor red ]
      let skip3 file-read-characters 1
      let templandcover file-read
      ;print "Location"
      ;print col
      ;print row
      ask patch col row [ set landcover templandcover set bin_list [0 0 0 0 0 0 0 0 0 0 0 0 ] ]
      ;print templandcover
      ifelse templandcover = 42
      [ ask patch col row [ set cut-off 8 ] ]
      [ ask patch col row [ set cut-off 10 ] ]
      ask patch col row [select-case templandcover [
        [11 105] ;water
        [12 9.9] ;ice
        [21 137] ;dev-op
        [22 134] ;dev-low
        [23 15] ;dev-med
        [24 13] ;dev-hi
        [31 38] ;barren
        [41 57] ;forest-dec
        [42 53] ;forest-ever
        [43 58] ;forest-mix
        [51 25] ;shrub-dwarf
        [52 27] ;shrub
        [71 47] ;herb
        [72 44] ;herb-seg
        [73 43] ;herb-lic
        [74 85] ;herb-moss
        [81 45] ;plant-past
        [82 22] ;plant-crop
        [90 87] ;wet-wood
        [95 94] ;wet-herb
        [255 125]
      ]]
      let skip4 file-read-characters 1
      ask patch col row [ set canopy2k1 file-read ]
      let skip5 file-read-characters 1
      ask patch col row [ set house1996 file-read ]
      let skip6 file-read-characters 1
      ask patch col row [ set house2k5 file-read ]
      let skip7 file-read-characters 1
      ask patch col row [ set frontage file-read ]
      let skip8 file-read-characters 1
      ask patch col row [ set lakesize file-read ]
      let skip9 file-read-characters 1
      ask patch col row [ set road file-read ]
      let skip10 file-read-characters 1
      ask patch col row [ set soil file-read ]
      let skip11 file-read-characters 1
      ask patch col row [ set ownership file-read ]
      let skip12 file-read-characters 1
      ask patch col row [ set zoning file-read ]
      ask patch col row [initialize-trees]
      ask patch col row
      [
        ifelse pxcor >= 0 and pxcor < 10 and pycor >= 40 and pycor < 50
        [
          set bird-range true
        ]
        [
          set bird-range false
        ]
      ]
    ]
    repeat 1252 [let skipline file-read-line]
  ]
  file-close
  initialize-matrix 41
  initialize-matrix 42
  initialize-matrix 43
  initialize-matrix 90
  ;set min_ba_41 [b_area] of min-one-of (patches with [landcover = 41]) [b_area]
  ;set max_ba_41 [b_area] of max-one-of (patches with [landcover = 41]) [b_area]
  set min_ba_41 [b_area] of min-one-of patches [b_area]
  set max_ba_41 [b_area] of max-one-of patches [b_area]
  
  ;set min_ba_42 [b_area] of min-one-of (patches with [landcover = 42]) [b_area]
  ;set max_ba_42 [b_area] of max-one-of (patches with [landcover = 42]) [b_area]
  
  ;set min_ba_43 [b_area] of min-one-of (patches with [landcover = 43]) [b_area]
  ;set max_ba_43 [b_area] of max-one-of (patches with [landcover = 43]) [b_area]
  
  ;set min_ba_90 [b_area] of min-one-of (patches with [landcover = 90]) [b_area]
  ;set max_ba_90 [b_area] of max-one-of (patches with [landcover = 90]) [b_area]
  
  ;initialize stuff
  ask patches with [landcover != 11] 
  [
    set herb_veg 1
    set bug_pop 1
  ]
  
  create-birds num-birds
  [
    set shape "bird side"
    set size .5
    set color red
    let xcoord random 10
    let ycoord random 10
    set ycoord ycoord + 40
    setxy xcoord ycoord
    set energy random 50
    set lifetime random 700
  ]
end

to select-case [value cases]
  foreach cases
  [
    ;print ?1
    if (item 0 ?1 = value) [ set pcolor (item 1 ?1) stop ]
  ]
end

to initialize-trees
  let weights_conif [0.556035896 0.258728096 0.185236008]
  let weights_deci [0.43 0.37 0.2]
  let weights_wet [0.424745355 0.350450241 0.224804403]
  let weights_mix [0.424745355 0.350450241 0.224804403]
  
  if landcover = 42 ;Coniferous
  [
    calc_mean_diam weights_conif
    generate_dist
  ]
  
  if landcover = 41 ;Deciduous
  [
    calc_mean_diam weights_deci
    generate_dist
  ]
  
  if landcover = 90 ;Forested Wetlands
  [
    calc_mean_diam weights_wet
    generate_dist
  ]
  
  if landcover = 43 ;Mixed
  [
    calc_mean_diam weights_mix
    generate_dist
  ]
  set tree_height [ 0 0 0 0 0 0 0 0 0 0 0 0 ]
  set volume [ 0 0 0 0 0 0 0 0 0 0 0 0 ]
set total_volume [ 0 0 0 0 0 0 0 0 0 0 0 0 ]
end

to calc_mean_diam [weights]
  let treesize [10 8 5]
  let rand random-float 1
    if rand < item 0 weights
    [
      ;call subroutine
      calc_mean_diam_sub
    ]
    if rand > item 0 weights and rand < (item 0 weights + item 1 weights)
    [
      set mean_diam item 1 treesize
    ]
    if rand > (item 0 weights + item 1 weights)
    [
      set mean_diam item 2 treesize
    ]
end

to calc_mean_diam_sub
  let rand random-float 1
  let treesize [0 2 4 6 8 10 15 20]
  let distr [0.125 0.25 0.375 0.5 0.625 0.75 0.875]
  ;uniform distribution i.e Pr[mean_diam = treesize(i)] = 1/8 or 0.125
  if rand < item 0 distr
  [
    set mean_diam item 0 treesize
  ]
  if rand > item 0 distr and rand < item 1 distr
  [
    set mean_diam item 1 treesize
  ]
  if rand > item 1 distr and rand < item 2 distr
  [
    set mean_diam item 2 treesize
  ]
  if rand > item 2 distr and rand < item 3 distr
  [
    set mean_diam item 3 treesize
  ]
  if rand > item 3 distr and rand < item 4 distr
  [
    set mean_diam item 4 treesize
  ]
  if rand > item 4 distr and rand < item 5 distr
  [
    set mean_diam item 5 treesize
  ]
  if rand > item 5 distr and rand < item 6 distr
  [
    set mean_diam item 6 treesize
  ]
  if rand > item 6 distr
  [
    set mean_diam item 7 treesize
  ]
end

to generate_dist
  if mean_diam = 0 [stop]
  let target_basal_area (random 50) + 60
  let running_basal_area 0
  let rand random-float 1
  ifelse rand < 0.5
  [
    ;normal diameter distribution
    set dist_type 0
    ;calculate coefficient of variation of a beta distribution
    let alpha 2
    let beta 5
    ;generate a random number from a beta distribution given a gamma distribution
    let x random-gamma alpha 1
    let y random-gamma beta 1
    let rand_beta x / (x + y)
    let cv rand_beta
    let sd cv * mean_diam
    while[running_basal_area < target_basal_area]
    [
      let tree_size random-normal mean_diam sd
      if tree_size >= 0 and tree_size <= 29
      [
        increment_tree_bin tree_size
        let basal_area 0.005454 * (tree_size ^ 2)
        set running_basal_area (running_basal_area + basal_area)
      ]
    ]
  ]
  [
    ;negative exponential diameter distribution
    set dist_type 1
    ;calculate probabilities
    let lamda 1 / mean_diam
    let fds [0 0 0 0 0 0 0 0 0 0 0 0]
    set fds replace-item 0 fds calc_fd lamda 1.5
    set fds replace-item 1 fds calc_fd lamda 4
    set fds replace-item 2 fds calc_fd lamda 6
    set fds replace-item 3 fds calc_fd lamda 8
    set fds replace-item 4 fds calc_fd lamda 10
    set fds replace-item 5 fds calc_fd lamda 12
    set fds replace-item 6 fds calc_fd lamda 14
    set fds replace-item 7 fds calc_fd lamda 16
    set fds replace-item 8 fds calc_fd lamda 18
    set fds replace-item 9 fds calc_fd lamda 20
    set fds replace-item 10 fds calc_fd lamda 22
    set fds replace-item 11 fds calc_fd lamda 26
   
    let fd_sum sum fds
    
    let distr [0 0 0 0 0 0 0 0 0 0 0 0]
    set distr replace-item 0 distr (item 0 fds / fd_sum)
    set distr replace-item 1 distr (item 1 fds / fd_sum)
    set distr replace-item 2 distr (item 2 fds / fd_sum)
    set distr replace-item 3 distr (item 3 fds / fd_sum)
    set distr replace-item 4 distr (item 4 fds / fd_sum)
    set distr replace-item 5 distr (item 5 fds / fd_sum)
    set distr replace-item 6 distr (item 6 fds / fd_sum)
    set distr replace-item 7 distr (item 7 fds / fd_sum)
    set distr replace-item 8 distr (item 8 fds / fd_sum)
    set distr replace-item 9 distr (item 9 fds / fd_sum)
    set distr replace-item 10 distr (item 10 fds / fd_sum)
    set distr replace-item 11 distr (item 11 fds / fd_sum)
    
    let prob [0 0 0 0 0 0 0 0 0 0 0]
    set prob replace-item 0 prob item 0 distr
    set prob replace-item 1 prob (item 0 distr + item 1 distr)
    set prob replace-item 2 prob (item 0 distr + item 1 distr + item 2 distr)
    set prob replace-item 3 prob (item 0 distr + item 1 distr + item 2 distr + item 3 distr)
    set prob replace-item 4 prob (item 0 distr + item 1 distr + item 2 distr + item 3 distr + item 4 distr)
    set prob replace-item 5 prob (item 0 distr + item 1 distr + item 2 distr + item 3 distr + item 4 distr + item 5 distr)
    set prob replace-item 6 prob (item 0 distr + item 1 distr + item 2 distr + item 3 distr + item 4 distr + item 5 distr
      + item 6 distr)
    set prob replace-item 7 prob (item 0 distr + item 1 distr + item 2 distr + item 3 distr + item 4 distr + item 5 distr
      + item 6 distr + item 7 distr)
    set prob replace-item 8 prob (item 0 distr + item 1 distr + item 2 distr + item 3 distr + item 4 distr + item 5 distr
      + item 6 distr + item 7 distr + item 8 distr)
    set prob replace-item 9 prob (item 0 distr + item 1 distr + item 2 distr + item 3 distr + item 4 distr + item 5 distr
      + item 6 distr + item 7 distr + item 8 distr + item 9 distr)
    set prob replace-item 10 prob (item 0 distr + item 1 distr + item 2 distr + item 3 distr + item 4 distr + item 5 distr
      + item 6 distr + item 7 distr + item 8 distr + item 9 distr + item 10 distr)
        
    ;loop
    while[running_basal_area < target_basal_area]
    [
      ;generate new tree, update bin and running_basal_area
      let tree_size 0
      let rand2 random-float 1
      if rand2 < item 0 prob
      [
        set bin_list replace-item 0 bin_list ((item 0 bin_list) + 1)
        ;set bin_2 bin_2 + 1
        set tree_size 2
      ]
      if rand2 > item 0 prob and rand2 < item 1 prob
      [
        set bin_list replace-item 1 bin_list ((item 1 bin_list) + 1)
        ;set bin_4 bin_4 + 1
        set tree_size 4
      ]
      if rand2 > item 1 prob and rand2 < item 2 prob
      [
        set bin_list replace-item 2 bin_list ((item 2 bin_list) + 1)
        ;set bin_6 bin_6 + 1
        set tree_size 6
      ]
      if rand2 > item 2 prob and rand2 < item 3 prob
      [
        set bin_list replace-item 3 bin_list ((item 3 bin_list) + 1)
        ;set bin_8 bin_8 + 1
        set tree_size 8
      ]
      if rand2 > item 3 prob and rand2 < item 4 prob
      [
        set bin_list replace-item 4 bin_list ((item 4 bin_list) + 1)
        ;set bin_10 bin_10 + 1
        set tree_size 10
      ]
      if rand2 > item 4 prob and rand2 < item 5 prob
      [
        set bin_list replace-item 5 bin_list ((item 5 bin_list) + 1)
        ;set bin_12 bin_12 + 1
        set tree_size 12
      ]
      if rand2 > item 5 prob and rand2 < item 6 prob
      [
        set bin_list replace-item 6 bin_list ((item 6 bin_list) + 1)
        ;set bin_14 bin_14 + 1
        set tree_size 14
      ]
      if rand2 > item 6 prob and rand2 < item 7 prob
      [
        set bin_list replace-item 7 bin_list ((item 7 bin_list) + 1)
        ;set bin_16 bin_16 + 1
        set tree_size 16
      ]
      if rand2 > item 7 prob and rand2 < item 8 prob
      [
        set bin_list replace-item 8 bin_list ((item 8 bin_list) + 1)
        ;set bin_18 bin_18 + 1
        set tree_size 18
      ]
      if rand2 > item 8 prob and rand2 < item 9 prob
      [
        set bin_list replace-item 9 bin_list ((item 9 bin_list) + 1)
        ;set bin_20 bin_20 + 1
        set tree_size 20
      ]
      if rand2 > item 9 prob and rand2 < item 10 prob
      [
        set bin_list replace-item 10 bin_list ((item 10 bin_list) + 1)
        ;set bin_22 bin_22 + 1
        set tree_size 22
      ]
      if rand2 > item 10 prob
      [
        set bin_list replace-item 11 bin_list ((item 11 bin_list) + 1)
        ;set bin_24 bin_24 + 1
        set tree_size 24
      ]
      let basal_area 0.005454 * (tree_size ^ 2)
      set running_basal_area (running_basal_area + basal_area)
    ]
  ]
  set b_area running_basal_area
end

to increment_tree_bin [tree_size]
  let bins [3 5 7 9 11 13 15 17 19 21 23]
  if tree_size < item 0 bins
  [
    set bin_list replace-item 0 bin_list ((item 0 bin_list) + 1)
    ;set bin_2 bin_2 + 1
  ]
  if tree_size >= item 0 bins and tree_size < item 1 bins
  [
    set bin_list replace-item 1 bin_list ((item 1 bin_list) + 1)
    ;set bin_4 bin_4 + 1
  ]
  if tree_size >= item 1 bins and tree_size < item 2 bins
  [
    set bin_list replace-item 2 bin_list ((item 2 bin_list) + 1)
    ;set bin_6 bin_6 + 1
  ]
  if tree_size >= item 2 bins and tree_size < item 3 bins
  [
    set bin_list replace-item 3 bin_list ((item 3 bin_list) + 1)
    ;set bin_8 bin_8 + 1
  ]
  if tree_size >= item 3 bins and tree_size < item 4 bins
  [
    set bin_list replace-item 4 bin_list ((item 4 bin_list) + 1)
    ;set bin_10 bin_10 + 1
  ]
  if tree_size >= item 4 bins and tree_size < item 5 bins
  [
    set bin_list replace-item 5 bin_list ((item 5 bin_list) + 1)
    ;set bin_12 bin_12 + 1
  ]
  if tree_size >= item 5 bins and tree_size < item 6 bins
  [
    set bin_list replace-item 6 bin_list ((item 6 bin_list) + 1)
    ;set bin_14 bin_14 + 1
  ]
  if tree_size >= item 6 bins and tree_size < item 7 bins
  [
    set bin_list replace-item 7 bin_list ((item 7 bin_list) + 1)
    ;set bin_16 bin_16 + 1
  ]
  if tree_size >= item 7 bins and tree_size < item 8 bins
  [
    set bin_list replace-item 8 bin_list ((item 8 bin_list) + 1)
    ;set bin_18 bin_18 + 1
  ]
  if tree_size >= item 8 bins and tree_size < item 9 bins
  [
    set bin_list replace-item 9 bin_list ((item 9 bin_list) + 1)
    ;set bin_20 bin_20 + 1
  ]
  if tree_size >= item 9 bins and tree_size < item 10 bins
  [
    set bin_list replace-item 10 bin_list ((item 10 bin_list) + 1)
    ;set bin_22 bin_22 + 1
  ]
  if tree_size >= item 10 bins
  [
    set bin_list replace-item 11 bin_list ((item 11 bin_list) + 1)
    ;set bin_24 bin_24 + 1
  ]
end

to-report calc_fd [lamda medi]
  report lamda * e ^ (lamda * medi)
end

to grow-forest
  ;show templast
  let is_forest 0
  set cord 0
  set mbf 0
  set money_pole 0
  set money_saw 0
  let treematrix matrix:make-constant 12 1 0
  matrix:set-column treematrix 0 bin_list
  let inter2 matrix:make-constant 12 1 0
  if landcover = 41
  [
    let inter1 matrix:times decid_matrix treematrix
    set inter2 matrix:plus decid_ingrow inter1
    set is_forest 1
  ]
  if landcover = 42
  [
    let inter1 matrix:times evergreen_matrix treematrix
    set inter2 matrix:plus evergreen_ingrow inter1
    set is_forest 1
  ]
  if landcover = 43
  [
    let inter1 matrix:times mixed_matrix treematrix
    set inter2 matrix:plus mixed_ingrow inter1
    set is_forest 1
  ]
  if landcover = 90
  [
    let inter1 matrix:times wet_matrix treematrix
    set inter2 matrix:plus wet_ingrow inter1
    set is_forest 1
  ]
  
  if is_forest = 0
  [
    stop
  ]
  
  set bin_list matrix:get-column inter2 0
end

to initialize-matrix [cover_id]
  let upgrowth [0 0 0 0 0 0 0 0 0 0 0 0]
  let mortality [0 0 0 0 0 0 0 0 0 0 0 0]
  let ingrowth [0 0 0 0 0 0 0 0 0 0 0 0]
  ;set b_area 0
  if cover_id = 41 ;deciduous
  [
    let counter 0
    repeat 12
    [
      let dia (counter + 1) * 2
      set upgrowth replace-item counter upgrowth (0.0164 - 0.0001 * 0.005454 * dia ^ 2 + 0.0055 * dia - 0.0002 * dia ^ 2)
      set mortality replace-item counter mortality (0.0336 - 0.0018 * dia + 0.0001 * dia ^ 2 - 0.00002 * s-constant * dia)
      set ingrowth replace-item counter ingrowth (18.187 - 0.097 * 0.005454 * dia ^ 2)
      ;set b_area b_area + (0.005454 * dia ^ 2)
      set counter counter + 1
    ]
  ]
  
  if cover_id = 42 ;evergreen
  [
    let counter 0
    repeat 12
    [
      let dia (counter + 1) * 2
      set upgrowth replace-item counter upgrowth (0.0069 - 0.0001 * 0.005454 * dia ^ 2 + 0.0059 * dia - 0.0002 * dia ^ 2)
      set mortality replace-item counter mortality (0.0418 - 0.0009 * dia)
      set ingrowth replace-item counter ingrowth (7.622 - 0.059 * 0.005454 * dia ^ 2)
      ;set b_area b_area + (0.005454 * dia ^ 2)
      set counter counter + 1
    ]
  ]
  if cover_id = 43 ;mixed
  [
    let counter 0
    repeat 12
    [
      let dia (counter + 1) * 2
      set upgrowth replace-item counter upgrowth (0.0134 - 0.0002 * 0.005454 * dia ^ 2 + 0.0051 * dia - 0.0002 * dia ^ 2 + 0.00002 * s-constant * dia)
      set mortality replace-item counter mortality (0.0417 - 0.0033 * dia + 0.0001 * dia ^ 2)
      set ingrowth replace-item counter ingrowth (4.603 - 0.035 * 0.005454 * dia ^ 2)
      ;set b_area b_area + (0.005454 * dia ^ 2)
      set counter counter + 1
    ]
  ]
  if cover_id = 90 ;wetland with threes
  [
    let counter 0
    repeat 12
    [
      let dia (counter + 1) * 2
      set upgrowth replace-item counter upgrowth (0.0134 - 0.0002 * 0.005454 * dia ^ 2 + 0.0051 * dia - 0.0002 * dia ^ 2 + 0.00002 * s-constant * dia)
      set mortality replace-item counter mortality (0.0417 - 0.0033 * dia + 0.0001 * dia ^ 2)
      set ingrowth replace-item counter ingrowth (4.603 - 0.035 * 0.005454 * dia ^ 2)
      ;set b_area b_area + (0.005454 * dia ^ 2)
      set counter counter + 1
    ]
  ]
  
  let columns [
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
    [0 0 0 0 0 0 0 0 0 0 0 0]
  ]
  
  let column_counter 0
  repeat 11
  [
    let temp (item column_counter columns)
    set temp replace-item column_counter temp ((1 - (item column_counter mortality)) * (1 - (item column_counter upgrowth)))
    set temp replace-item (column_counter + 1) temp ((1 - (item column_counter mortality)) * (item column_counter upgrowth))
    set columns replace-item column_counter columns temp
    set column_counter column_counter + 1
    ;show temp
  ]
  
  let templast (item 11 columns)
  set templast replace-item 11 templast (1 - (item 11 mortality))
  set columns replace-item 11 columns templast
  
  let ingrowthcolumn [ 0 0 0 0 0 0 0 0 0 0 0 0 ]
  set ingrowthcolumn replace-item 0 ingrowthcolumn (item 0 ingrowth)
  
  if cover_id = 41
  [
    set decid_matrix matrix:from-column-list columns
    set decid_ingrow matrix:make-constant 12 1 0
    matrix:set-column decid_ingrow 0 ingrowthcolumn
  ]
  if cover_id = 42
  [
    set evergreen_matrix matrix:from-column-list columns
    set evergreen_ingrow matrix:make-constant 12 1 0
    matrix:set-column evergreen_ingrow 0 ingrowthcolumn
  ]
  if cover_id = 43
  [
    set mixed_matrix matrix:from-column-list columns
    set mixed_ingrow matrix:make-constant 12 1 0
    matrix:set-column mixed_ingrow 0 ingrowthcolumn
  ]
  if cover_id = 90
  [
    set wet_matrix matrix:from-column-list columns
    set wet_ingrow matrix:make-constant 12 1 0
    matrix:set-column wet_ingrow 0 ingrowthcolumn
  ]
end

to go
  let current_time ticks
  ask patches with [landcover != 11] [ init_herbs init_bugs ]
  if (current_time mod 365) = 0
  [
    set total_profit total_profit + current_profit
    set current_profit 0
    set total_saw total_saw + currentyear_saw
    set total_pole total_pole + currentyear_pole
    set currentyear_saw 0
    set currentyear_pole 0
    ask patches with [landcover = 41]
    [
      grow-forest
      if b_area > max_ba_41
      [ set max_ba_41 b_area ]
    ]
    ask patches with [landcover = 42]
    [
      grow-forest
      if b_area > max_ba_41
      [ set max_ba_41 b_area ]
    ]
    ask patches with [landcover = 43]
    [
      grow-forest
      if b_area > max_ba_41
      [ set max_ba_41 b_area ]
    ]
    ask patches with [landcover = 90]
    [
      grow-forest
      if b_area > max_ba_41
      [ set max_ba_41 b_area ]
    ]
    if show-growth = true and show-growth-herbs = false
    [
      ask patches with [landcover = 41] [ draw-forest min_ba_41 max_ba_41 ]
      ask patches with [landcover = 42] [ draw-forest min_ba_41 max_ba_41 ]
      ask patches with [landcover = 43] [ draw-forest min_ba_41 max_ba_41 ]
      ask patches with [landcover = 90] [ draw-forest min_ba_41 max_ba_41 ]
    ]
  ]
  
  ask birds
  [
    bird-move
    bird-eat
    bird-repro
    bird-die
  ]
  tick
end

to init_herbs
  let doy ticks mod 365
  ;let r_p 0.5
  ;let r_die 0.1
  ;let K 5
  ;initialization / budding
  ;if landcover = 41 or landcover = 42 or landcover = 43 or landcover = 90
  ;[
    ;set K 3
  ;]
  ;if doy = 1 [set herb_veg herb_veg + 1]
  
  let delta_pt 0
  
  ;calculate delta_pt
  ;ifelse doy < 175
  ;[
    ;set delta_pt r_p * herb_veg * (1 - (herb_veg / K))
  ;]
  ;[
    ;set delta_pt (-1) * r_p * herb_veg
  ;]
  
  ;New population model
  set delta_pt (herb_veg * r_p) - (herb_veg * bug_pop * plant_eating)
  
  set herb_veg herb_veg + delta_pt
  
  if show-growth-herbs = true and show-growth = false
  [
    set pcolor scale-color green herb_veg 6 0
  ]
end

to init_bugs
  let doy ticks mod 365
  ;let r_h 0.1
  
  let delta_ht 0
  
  ;if doy = 1 [set bug_pop bug_pop + 1]
  
  ;calcualte delta_ht
  set delta_ht (bug_pop * herb_veg * r_h) - (bug_pop * bug_die)
  
  set bug_pop bug_pop + delta_ht
  
end


to draw-forest [min_ba max_ba ]
  let self-land landcover
  set pcolor scale-color pcolor b_area min_ba max_ba
end

to draw-cut
  if mouse-down? and mouse-inside? [
    ask patch mouse-xcor mouse-ycor [
      if landcover = 41 or landcover = 42 or landcover = 43 or landcover = 90
      [
        calc_profit
        if strategy = "clear-cut"
        [
          set bin_list [ 0 0 0 0 0 0 0 0 0 0 0 0 ]
          show money_pole
          show money_saw
          set current_profit (current_profit + money_pole + money_saw)
          show bin_list
        ]
        if strategy = "diameter"
        [
          let index (dia-cut / 2) - 1
          let index-end 12 - index
          repeat index-end
          [
            set bin_list replace-item index bin_list 0
            set index index + 1
          ]
        
          let old_pole money_pole
          let old_saw money_saw
          calc_profit
          set current_profit (current_profit + (old_pole - money_pole) + (old_saw - money_saw))
          set currentyear_pole currentyear_pole + cord
          set currentyear_saw currentyear_saw + mbf
          show bin_list
        ]
        if strategy = "bdq"
        [
          ifelse b_area > B
          [
            let counter 0
             repeat 4
             [
               let new_b_area 0
               let new_bin 0
               let inner_count 0
               let endpoint 3
               let startpoint 0
               if counter = 0 [ set endpoint 2 set startpoint 0 ]
               if counter = 1 [ set endpoint 3 set startpoint 2 ]
               if counter = 2 [ set endpoint 2 set startpoint 5 ]
               if counter = 3 [ set endpoint 5 set startpoint 7 ]
               repeat endpoint
               [
                 set new_bin new_bin + item (startpoint + inner_count) bin_list
                 let curr_dia (startpoint + inner_count + 1) * 2
                 set new_b_area (new_b_area + (item (startpoint + inner_count) bin_list) * .005454 * curr_dia ^ 2)
                 set inner_count inner_count + 1
               ]
               let new_bin_barea 0
               let target_q 0
               if q = 1.2
               [
                 set target_q select-case-bdq counter [
                   [0 0.03]
                   [1 0.19]
                   [2 0.21]
                   [3 0.6]
                 ]
               ]
               if q = 1.3
               [
                 set target_q select-case-bdq counter [
                   [0 0.05]
                   [1 0.26]
                   [2 0.24]
                   [3 0.5]
                 ]
               ]
               if q = 1.4
               [
                 set target_q select-case-bdq counter [
                   [0 0.08]
                   [1 0.32]
                   [2 0.25]
                   [3 0.43]
                 ]
               ]
               if q = 1.5
               [
                 set target_q select-case-bdq counter [
                   [0 0.11]
                   [1 0.39]
                   [2 0.26]
                   [3 0.35]
                 ]
               ]
               if q = 1.6
               [
                 set target_q select-case-bdq counter [
                   [0 0.14]
                   [1 0.45]
                   [2 0.26]
                   [3 0.29]
                 ]
               ]
               if q = 1.7
               [
                 set target_q select-case-bdq counter [
                   [0 0.19]
                   [1 0.51]
                   [2 0.25]
                   [3 0.24]
                 ]
               ]
               if q = 1.8
               [
                 set target_q select-case-bdq counter [
                   [0 0.23]
                   [1 0.56]
                   [2 0.24]
                   [3 0.2]
                 ]
               ]
               let target_val (target_q * B)
               if new_b_area > target_val
               [
                 let old_pole money_pole
                 let old_saw money_saw
                 let ratio target_val / new_b_area
                 let bin_counter 0
                 repeat endpoint
                 [
                   set bin_list (replace-item (bin_counter + startpoint) bin_list ((item (bin_counter + startpoint) bin_list) * ratio))
                   set bin_counter bin_counter + 1
                 ]
                 calc_profit
                 set current_profit (current_profit + (old_pole - money_pole) + (old_saw - money_saw))
               ]
               set counter counter + 1
             ]
          ]
          [
            show "b_area below B"
          ]
        ]
      ]
    ]
  ]
end

to-report select-case-42 [value cases]
  foreach cases
  [
    ;print ?1
    if (item 0 ?1 = value) [ report (item 1 ?1) stop ]
  ]
end

to-report select-case-other [value cases]
  foreach cases
  [
    ;print ?1
    if (item 0 ?1 = value) [ report (item 1 ?1) stop ]
  ]
end

to-report select-case-bdq [value cases]
  foreach cases
  [
    ;print ?1
    if (item 0 ?1 = value) [ report (item 1 ?1) stop ]
  ]
end

to calc_profit
  let counter 0
  set b_area 0
  repeat 12
  [
    let dia (counter + 1) * 2
    set b_area (b_area + (0.005454 * dia ^ 2) * (item counter bin_list))
    set counter counter + 1
  ]
  
  set counter 2
  set cord 0
  set mbf 0
  repeat 10
  [
    let T 1
    let dia (counter + 1) * 2
    ifelse dia > cut-off
    [ set T (1.00001 - (9 / dia)) ]
    [ set T (1.00001 - (5 / dia)) ]
    if landcover = 41
    [
      set tree_height replace-item counter tree_height (4.5 + 6.43 * ((1 - exp(-0.24 * dia)) ^ 1.34) * (s-constant ^ 0.47) * (T ^ 0.73) * (b_area ^ 0.08))
      set volume replace-item counter volume (2.706 + 0.002 * (dia ^ 2) * (item counter tree_height))
    ]
    if landcover = 42
    [
      set tree_height replace-item counter tree_height (4.5 + 5.32 * ((1 - exp(-0.23 * dia)) ^ 1.15) * (s-constant ^ 0.54) * (T ^ 0.83) * (b_area ^ 0.06))
      set volume replace-item counter volume (1.375 + 0.002 * (dia ^ 2) * (item counter tree_height))
    ]
    if landcover = 43 or landcover = 90
    [
      set tree_height replace-item counter tree_height (4.5 + 7.19 * ((1 - exp(-0.28 * dia)) ^ 1.44) * (s-constant ^ 0.39) * (T ^ 0.83) * (b_area ^ 0.11))
      set volume replace-item counter volume (0.002 * (dia ^ 2) * (item counter tree_height))
    ]
    
    set total_volume replace-item counter total_volume ((item counter bin_list) * (item counter volume))
    
    ifelse dia > cut-off
    [
      let con_fact 0
      ifelse landcover = 42
      [
        set con_fact select-case-42 dia [
          [10 0.783] ;water
          [12 0.829] ;ice
          [14 0.858] ;dev-op
          [16 0.878] ;dev-low
          [18 0.895] ;dev-med
          [20 0.908] ;dev-hi
          [22 0.917] ;barren
          [24 0.924] ;forest-dec
        ]
      ]
      [
        set con_fact select-case-other dia [
          [12 0.832] ;ice
          [14 0.861] ;dev-op
          [16 0.883] ;dev-low
          [18 0.9] ;dev-med
          [20 0.913] ;dev-hi
          [22 0.924] ;barren
          [24 0.933] ;forest-dec
        ]
      ]
      
      set mbf (mbf + ((item counter total_volume) * con_fact) / 12)
    ]
    [
      set cord (cord + (item counter total_volume) / 128)
    ]
    
    set counter counter + 1
  ]
  
  if landcover = 41
  [
    set money_pole cord * 12
    set money_saw mbf * 151
  ]
  if landcover = 42
  [
    set money_pole cord * 14
    set money_saw mbf * 147
  ]
  if landcover = 43 or landcover = 90
  [
    set money_pole cord * 13
    set money_saw mbf * 127
  ]
end

to make-movie
  user-message "First, save your new movie file (choose a name ending with .mov)"
  let path user-new-file
  if not is-string? path [ stop ] ;; stop if user canceled

  ;; run the model
  setup
  movie-start path
  movie-grab-view
  while [ ticks < (365 * 10) ]
    [ go
      movie-grab-view ]

  ;; export the movie
  movie-close
  user-message (word "Exported movie to " path)
end

to bird-move
  move-to one-of patches with [bird-range = true] in-radius 2.1
  set energy energy - .5
end

to bird-eat
  let want 0.00000018
  ifelse bug_pop > want
  [
    ask patch-here [set bug_pop bug_pop - want]
    set energy energy + 1.5
  ]
  [
    let ratio bug_pop / want
    set energy energy + 1.5 * ratio
    ask patch-here [set bug_pop 0]
  ]
  
  set lifetime lifetime - 1
end

to bird-repro
  let date ticks mod 365
  if date > 100 and date < 200
  [
    if energy >= 160
    [
      hatch ((random 2) + 1)
      [
        set energy random 50
        set lifetime random 700
      ]
      
      set energy 50
    ]
  ]
end

to bird-die
  if lifetime <= 0 or energy <= 0
  [
    die
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
211
10
849
669
51
51
6.1
1
10
1
1
1
0
0
0
1
-51
51
-51
51
0
0
1
ticks
30.0

BUTTON
20
21
93
54
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
101
21
177
54
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
21
63
177
96
show-growth
show-growth
1
1
-1000

CHOOSER
21
170
176
215
strategy
strategy
"clear-cut" "diameter" "bdq"
0

SLIDER
22
300
179
333
dia-cut
dia-cut
6
24
20
2
1
NIL
HORIZONTAL

MONITOR
989
14
1087
59
NIL
current_profit
17
1
11

MONITOR
990
68
1086
113
NIL
total_profit
17
1
11

BUTTON
21
225
176
258
NIL
draw-cut
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
21
338
180
371
q
q
1.2
1.8
1.2
.1
1
NIL
HORIZONTAL

SLIDER
22
376
180
409
B
B
60
140
60
10
1
NIL
HORIZONTAL

SWITCH
21
104
177
137
show-growth-herbs
show-growth-herbs
1
1
-1000

MONITOR
992
119
1087
164
NIL
currentyear_saw
17
1
11

BUTTON
21
512
169
545
NIL
make-movie
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
863
13
958
58
DOY
ticks mod 365
17
1
11

PLOT
865
181
1085
331
herbacious vegetation
DOY
Average-amount
0.0
10.0
0.0
5.0
true
false
"" ""
PENS
"bug" 1.0 0 -16777216 true "" "plot mean [bug_pop] of patches with [landcover != 11]"
"herb" 1.0 0 -7500403 true "" "plot mean [herb_veg] of patches with [landcover != 11]"

PLOT
866
361
1084
511
Birds
Time
Number
0.0
200.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count birds"

SLIDER
862
534
1034
567
r_p
r_p
0
1
0.2
0.05
1
NIL
HORIZONTAL

SLIDER
864
576
1036
609
r_h
r_h
0
1
0.2
0.05
1
NIL
HORIZONTAL

SLIDER
867
619
1039
652
plant_eating
plant_eating
0
1
0.3
0.05
1
NIL
HORIZONTAL

SLIDER
869
664
1041
697
bug_die
bug_die
0
1
0.3
0.05
1
NIL
HORIZONTAL

SLIDER
25
437
197
470
num-birds
num-birds
100
1000
150
10
1
NIL
HORIZONTAL

MONITOR
867
85
924
130
Birds
count birds
17
1
11

@#$#@#$#@
## ## WHAT IS IT?

This section could give a general understanding of what the model is trying to show or explain.

## ## HOW IT WORKS

This section could explain what rules the agents use to create the overall behavior of the model.

## ## HOW TO USE IT

This section could explain how to use the model, including a description of each of the items in the interface tab.

## ## THINGS TO NOTICE

This section could give some ideas of things for the user to notice while running the model.

## ## THINGS TO TRY

This section could give some ideas of things for the user to try to do (move sliders, switches, etc.) with the model.

## ## EXTENDING THE MODEL

This section could give some ideas of things to add or change in the procedures tab to make the model more complicated, detailed, accurate, etc.

## ## NETLOGO FEATURES

This section could point out any especially interesting or unusual features of NetLogo that the model makes use of, particularly in the Procedures tab. It might also point out places where workarounds were needed because of missing features.

## ## RELATED MODELS

This section could give the names of models in the NetLogo Models Library or elsewhere which are of related interest.

## ## CREDITS AND REFERENCES

This section could contain a reference to the model's URL on the web if it has one, as well as any other necessary credits or references.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bird side
false
0
Polygon -7500403 true true 0 120 45 90 75 90 105 120 150 120 240 135 285 120 285 135 300 150 240 150 195 165 255 195 210 195 150 210 90 195 60 180 45 135
Circle -16777216 true false 38 98 14

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
