breed [deer adeer]
breed [wolves wolf]
deer-own [ energy gender lifetime last_mate pregnant fought ]
wolves-own [ energy packsize fought stationary hungry eatcount ]
;;1 = male, 0 = female

breed [garlic-mustards garlic-mustard] ; Define garlic mustard plant agent
breed [wildflowers wildflower] ; Define wildflower plant agent
breed [bees bee] ; Define solitary bees

bees-own [ time-since-last-found energy ]

globals [ max_food base_energy max-eatcount]

to setup
  clear-all
  set max-eatcount 10
  setup-landscape
  set-default-shape deer "cow"
  create-deer number-deer [
    set size 2.5
    set color brown - 3
    setxy random-xcor random-ycor
    set energy random 10  ;start with a random amt. of energy
    set gender random 2
    set lifetime random 10
    set last_mate nobody
  ]
  set-default-shape wolves "wolf"
  create-wolves pack_number [
    set size 3.5
    set color gray
    setxy random-xcor random-ycor
    set energy 20
    set eatcount max-eatcount
    set packsize random 5
  ]
  set max_food 20
  set base_energy 10
  setup-plot
  do-plot
end

to go
  ;garlic-mustard / bee model 
  ask bees
  [
    search
    if time-since-last-found = 0 [drink-nectar ]
    reproduce-bees
    check-death
  ]
  ask garlic-mustards 
  [ 
    spread 
    update-health-garlic-mustard 
  ] 
  ask wildflowers 
  [ 
    update-health-wildflower
    reproduce-wildflowers  
    reopen-flower
  ] 
  
  ;wolf / deer model
  if not any? wolves [ stop ]
  if not any? deer [ stop ]
  ask deer
  [ 
    ;if count deer-here > 1 [die] ;patch capacity for deer
    move
    deer-repro
    ;fight
    deer-eat-wildflower
    eat-weeds
    set lifetime (lifetime - 1)
    death 
  ]
  ask wolves
  [
    ;show energy
    if stationary = 1
    [ set color red ]
    fight
    pack_eat
    pack_grow
    pack_death
  ]
  ask wolves [ set fought 0 ]
  tick
  do-plot
end

to setup-landscape
  ask patches 
  [
    set pcolor yellow 
  ]
  
  ; add shade clumps
  ask n-of num-shade-clumps patches
  [
    ask n-of 100 patches in-radius 7
    [
      set pcolor green
    ]
  ]
  
  ; add garlic-mustard and wildflower agents
  create-garlic-mustards num-garlic-mustards
  [
    set size 2
    set color 25
    set shape "plant"
    setxy random-xcor random-ycor
  ]
  
  create-wildflowers num-wildflowers
  [
    set size 2
    set color violet
    set shape "flower"
    setxy random-xcor random-ycor
  ]
  
  create-bees num-bees
  [
    set color 43 
    set size 0.6
    setxy random-xcor random-ycor
    set time-since-last-found 999
    set energy 150
    set shape "wheel"
  ]
end

to move 
  rt random 50
  lt random 50
  fd 1
  ;; moving takes some energy
  set energy energy - 1
end

to deer-eat-wildflower
  if count wildflowers-here > 0
  [
    ask n-of 1 wildflowers-here [die]
    set energy energy + wildflower-energy 
  ]
end

to eat-weeds
  ;; gain "weed-energy" by eating weeds
  if gender = 1
  [
    let female one-of deer-here with [gender = 0]
    if female != nobody
    [
    ]
  ]
  if count garlic-mustards-here > 0
  [ 
    ask n-of 1 garlic-mustards-here [die] 
    set energy energy + weed-energy 
  ]
end

to deer-repro
  if pregnant = 1
  [
    hatch 1
    [
      set lifetime random 10
      set energy random 10
      fd 1
    ]
  ]
  if pregnant > 0
  [
    set pregnant pregnant - 1
    stop
  ]
  if energy > birth-threshold
  [
    set energy energy / 2
    set pregnant 3
  ]
end

to death     ;; deer procedure
  ;; die if you run out of energy
  if energy <= 0 [ die ]
  if lifetime <= 0 [ die ]
end

to fight     ;; wolf procedure
  if stationary = 1 [ stop ]
  if fought = 1 [ stop ]
  let enemy one-of other wolves in-radius 5
  ifelse enemy != nobody
  [
    ask enemy [ set fought 1 ]
    ifelse [packsize] of enemy < [packsize] of self
    [ ask enemy
      [
        set stationary 0
        set packsize packsize * 3 / 5
      ]
      set stationary 1
      set packsize packsize * 4 / 5
    ]
    [ set stationary 0
      ask enemy [
        set stationary 1
        set packsize packsize * 4 / 5
      ]
      set packsize packsize * 3 / 5
    ]
  ]
  [ set stationary 1 ]
  
  set fought 1
end

to pack_eat
  ;if eatcount > 0
  ;[
   ; set eatcount eatcount - 1
    ;stop
  ;]
  if stationary = 0
  [
    set energy energy - 2
    set hungry hungry + 1
    stop
  ]
  let prey one-of deer in-radius 4 with [energy > 0]
  ifelse prey != nobody
  [
    set energy energy + [energy] of prey
    ask prey [ die ]
    set eatcount max-eatcount
    set hungry 0
  ]
  [
    set energy energy - 2
    set hungry hungry + 1
  ]
  if hungry > 2 [ set stationary 0 ]
end

to pack_grow
  if packsize >= 8
  [
    hatch 1
    [
      set energy 10
      set eatcount max-eatcount
      set packsize 3
      set stationary 0
      jump 6
    ]
    
    set packsize 5
  ]
  ifelse energy >= max_food
  [
    set packsize packsize + 2
    set energy base_energy
  ]
  [
    if energy <= 0
    [
      set packsize packsize - 1
      set energy base_energy
    ]
  ]
end

to pack_death
  if packsize <= 0
  [
    die
  ]
end

;;; plotting procedures

to setup-plot
  set-current-plot "Populations"
  set-plot-y-range 0 number-deer
end

to do-plot
  set-current-plot "Populations"
  set-current-plot-pen "wildflowers"
  plot count wildflowers / 4
  set-current-plot-pen "deer"
  plot count deer
  set-current-plot-pen "weeds"
  plot count garlic-mustards / 4
  set-current-plot-pen "wolves"
  plot count wolves
end

;garlic / bee model procedures
to spread
  ask n-of 1 neighbors
  [
    ; normal spread
    ; patch capacity for garlic mustard plants
    if count garlic-mustards-here < garlic-patch-capacity
    [
      sprout-garlic-mustards 1
      [
        set size 2
        set color 25 
        set shape "plant"
        setxy pxcor pycor
      ]
    ]
  ]  
end

to update-health-wildflower
  ask wildflowers
  [
    if count garlic-mustards-here > 0
    [
      die
    ]
    
    ;account for overcrowding
    if count wildflowers-here > wildflower-patch-capacity
    [
      die
    ]
  ]
end

to update-health-garlic-mustard
  ask garlic-mustards with [pcolor = yellow]
  [
    set color color + 0.5
    if color = 29 [die]
  ]
end

to reopen-flower  
  if color = red
  [
    if random 100 < 20 [ set color violet ] 
  ]
end

to search
  ifelse time-since-last-found <= 20
  [right (random 181) - 90]
  [right (random 210) - 10]
  
  set energy (energy - 1)
  
  forward 1
  
  ifelse count wildflowers-here > 0
  [ set time-since-last-found 0 ]
  [ set time-since-last-found time-since-last-found + 1 ]
  
end

to drink-nectar
  if count wildflowers-here > 0
  [
    set energy (energy + 20)
    ask wildflowers-here
    [
      set color red
    ]
  ]
end

to reproduce-bees
  ask bees 
  [
    if random 100 < bee-reproduce-rate
    [
       if energy > 50 
       [
         set energy (energy - 50)
         hatch 1 [ set energy 40 ] 
       ]
    ]
  ]
end

to check-death
  ask bees
  [
    if energy <= 0 [die]
  ]
  
  ;account for overpopulation / bee patch capacity
  if count bees-here > bee-patch-capacity
  [
    die
  ]
  
end

to reproduce-wildflowers
  if color = red
    [ 
       set color violet
       hatch-wildflowers 1 
       [
         set size 2 
         set color violet
         set shape "flower"
         set heading random 360
         forward random 10
       ]      
     ]    
end


; Copyright 2001 Uri Wilensky. All rights reserved.
; The full copyright notice is in the Information tab.
@#$#@#$#@
GRAPHICS-WINDOW
296
13
798
536
20
20
12.0
1
10
1
1
1
0
1
1
1
-20
20
-20
20
1
1
1
ticks

BUTTON
86
83
141
116
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL

BUTTON
151
83
206
116
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL

SLIDER
8
173
139
206
wildflower-energy
wildflower-energy
0.0
10.0
10
0.5
1
NIL
HORIZONTAL

SLIDER
153
174
275
207
weed-energy
weed-energy
0.0
10.0
3
0.5
1
NIL
HORIZONTAL

SLIDER
35
42
261
75
number-deer
number-deer
0.0
500.0
220
10
1
NIL
HORIZONTAL

SLIDER
65
127
225
160
birth-threshold
birth-threshold
0.0
20.0
15
1.0
1
NIL
HORIZONTAL

PLOT
4
228
275
424
Populations
Time
Pop
0.0
100.0
0.0
111.0
true
true
PENS
"wildflowers" 1.0 0 -10899396 true
"deer" 1.0 0 -13345367 true
"weeds" 1.0 0 -8630108 true
"wolves" 1.0 0 -16777216 true

MONITOR
186
424
275
469
count deer
count deer
1
1
11

SLIDER
55
511
227
544
pack_number
pack_number
0
100
15
1
1
NIL
HORIZONTAL

MONITOR
84
429
170
474
NIL
count wolves
17
1
11

SLIDER
838
33
1015
66
num-shade-clumps
num-shade-clumps
0
10
5
1
1
NIL
HORIZONTAL

SLIDER
839
72
1027
105
num-garlic-mustards
num-garlic-mustards
0
200
50
10
1
NIL
HORIZONTAL

SLIDER
839
111
1011
144
num-wildflowers
num-wildflowers
0
500
400
10
1
NIL
HORIZONTAL

SLIDER
840
151
1012
184
num-bees
num-bees
0
100
50
10
1
NIL
HORIZONTAL

SLIDER
841
213
1028
246
garlic-patch-capacity
garlic-patch-capacity
1
5
1
1
1
NIL
HORIZONTAL

SLIDER
841
253
1056
286
wildflower-patch-capacity
wildflower-patch-capacity
1
5
1
1
1
NIL
HORIZONTAL

SLIDER
842
352
1020
385
bee-reproduce-rate
bee-reproduce-rate
0
100
70
10
1
NIL
HORIZONTAL

SLIDER
841
292
1015
325
bee-patch-capacity
bee-patch-capacity
1
5
2
1
1
NIL
HORIZONTAL

MONITOR
845
414
926
459
NIL
count bees
17
1
11

MONITOR
943
414
1064
459
NIL
count wildflowers
17
1
11

MONITOR
846
471
998
516
NIL
count garlic-mustards\n
17
1
11

@#$#@#$#@
WOLF, DEER, FLOWER, WEED, AND BEES MODEL

PURPOSE

This model was designed to represent a dynamic equilibrium among a hierarchy of organisms on a simplified landscape in Wisconsin.  Wolves feed on deer, deer feed on wildflowers, bees drink the nectar of flowers and pollinate them, and an invasive weed (i.e., garlic mustard) competes for space.  

ENTITIES, STATE VARIABLES, AND SCALES
Our landscape patches are characterized by their color:
-yellow: full sun
-light green: shade

Global Variables: 
-Initial number of wildflowers
-Initial number of garlic mustard plants
-Initial number of bees
-Max food for wolf to grow in new pack 
-Base_energy of wolf pack: reserve energy a wolf pack has before starvation reduces its numbers

Landscape specifications:
-Number of clumps of shade 

Carrying Capacity
-Number of garlic-mustard plants per patch
-Number of wildflowers per patch
-Number of bees per patch

The model has 5 agents - wolf packs, deer, wildflowers, garlic mustard, and honey bees.  
1. Wolf packs are characterized by their energy level, hunger level (eatcount), pack size, and territory defense status (stationary).  
2. Deer are characterized by their energy level and age (lifetime).
3. Garlic mustards are characterized by their color and location.
4. Wildflowers are characterized by their location and color.
5. Honey bees are characterized by their location, energy level and a variable that holds the number of time steps since it found the last wildflower. 

The simulation lasts until wolves or deer die out or until it is ended by the user.  

PROCESS OVERVIEW AND SCHEDULING

On each time step, the deer move, reproduce if they have enough energy, search to find and eat nearby wildflowers, age, and die if they run out of energy or grow too old.  

On each time step wolf packs potentially fight for territory with a nearby pack where some pack members die, and if hungry, search for deer to eat, reproduce if energy needs are met, and potentially die out if all members die.  

On each time step each bee also moves once  and thereby loses energy. If a wildflower is on the new location the bee drinks nectar from it and thereby gains energy. It reproduces if its energy reaches a certain level and dies if the energy level drops to zero.

On each time step, each garlic mustard plant spreads once. Each garlic mustard plant will update their health. 

Afterwards, each wildflower updates their health once. If a new garlic mustard plant is on the location, the wildflower dies. Every wildflower that was fed on by a bee closes and it reopens at a certain rate. The wildflower is also pollinated and reproduces at a certain rate.

DESIGN CONCEPTS

The model is driven by energy needs and life history of the different organisms and their ability to meet those needs in a diverse landscape.  It is based upon a wolf-deer system in Wisconsin with the difference of wolves being the only predator of deer.  Wolves operate as packs and eat at a much less frequent interval than deer.  This is a typical behavior of a predator compared to its herbivorous prey.  Both wolf and deer reproduction is driven by energy requirements and wolves absorb the energy of the deer they consume.  
Deer gain energy from the wildflowers and can gain energy from the weeds(garlic-mustard plants), but it is much less nutritious.

The sub models of plants and bees revolve around the interaction between garlic mustard plants, wildflowers, bees and the corresponding landscape. 
Wildflowers and bees are dependent on each other for feeding and reproduction. 
Garlic mustard grows well in the shade, and is not commonly found in sunny habitats. Garlic mustard is a rapidly spreading woodland weed that displaces native woodland wildflowers in Wisconsin.  (Source: Wisconsin DNR) 

INITIALIZATION

The landscape is randomly initialized with patches of full sun and shade. A number of healthy garlic mustard plants, wildflowers and bees are placed randomly on the landscape. Wolves and deer are also randomly generated and placed across the map.

INPUT DATA

There is no input data.

SUBMODELS

Deer submodel
- Move: move randomly across the landscape.
- Deer-repro: reproduce if pregnant, will set to pregnancy period if reaching certain energy.
- Deer-eat-wildflower: deer eat wildflowers and increase energy based on the energy of the wildflower
- Eat-weeds: deer eat the weed (garlic-mustard) and increase energy based on the energy of the weed (garlic-mustard)
- Death: if no energy or reaching a certain age, then die.

Wolves submodel
- Fight: a wolf pack will fight with another wolf pack that is close by. The winning side gains control of a territory in which it can hunt and will become stationary.  Both wolf packs will decrease in size (losing side suffers more and is displaced).
- Pack-eat: once the hunger level reaches a certain level, the pack will search for deer in its territory to eat. If a pack with a territory cannot find food for several time steps, it becomes mobile to search for new territory. Packs without territory cannot hunt.
- Pack-grow: pack size will grow if the pack reaches a specified energy level. Packs that reach a specified size will split into two packs. One pack stays on the territory, and the other pack is displaced to find another territory. If the energy level of a pack decreases past a specified level, the pack looses a member. 
- Pack-death: the wolf pack will die out if all of the wolves in it die. 

Bees Submodels
- Search: Check the number of time steps since the last wildflower was found. If it is smaller or equal to 20 bee continues to search in the neighborhood, if not it searches in wide sweeps.
- Drink Nectar: Check whether a wildflower is on the patch. If true bee gains 20 units of energy and wildflower closes (i.e. changes color).
- Reproduce: Check if energy level is above 50. If true hatch one new bee. The new bee has energy level 40, the parent bee loses 50 units of energy.
- Check for Death: Check if the energy level equals zero. If true then bee dies.

Garlic Mustard Submodels
- Spread: randomly select 1 neighbor. Create and add a healthy garlic mustard agent to it.
- Update health (garlic mustard): if a garlic mustard plant is in a sun patch, its health will decrease until it dies. This is specified by increasing the color value of the orange garlic mustard plant by one each tick it lies in the sun patch. When the color value reaches the lightest orange the garlic mustard will die. 

Wildflowers Submodels
-Update health (wildflower): if patch contains both a wildflower and a garlic mustard agent, wildflower dies.
- Reopen-flower: Check the color of the wildflower. If red (i.e. closed) reopen with a certain probability.
- Reproduce-wildflowers: Check color of wildflower. If red (i.e. closed and therefore pollinated) reproduce with a certain probability.


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

rabbit
false
0
Circle -7500403 true true 76 150 148
Polygon -7500403 true true 176 164 222 113 238 56 230 0 193 38 176 91
Polygon -7500403 true true 124 164 78 113 62 56 70 0 107 38 124 91

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

wolf
false
0
Polygon -7500403 true true 75 225 97 249 112 252 122 252 114 242 102 241 89 224 94 181 64 113 46 119 31 150 32 164 61 204 57 242 85 266 91 271 101 271 96 257 89 257 70 242
Polygon -7500403 true true 216 73 219 56 229 42 237 66 226 71
Polygon -7500403 true true 181 106 213 69 226 62 257 70 260 89 285 110 272 124 234 116 218 134 209 150 204 163 192 178 169 185 154 189 129 189 89 180 69 166 63 113 124 110 160 111 170 104
Polygon -6459832 true true 252 143 242 141
Polygon -6459832 true true 254 136 232 137
Line -16777216 false 75 224 89 179
Line -16777216 false 80 159 89 179
Polygon -6459832 true true 262 138 234 149
Polygon -7500403 true true 50 121 36 119 24 123 14 128 6 143 8 165 8 181 7 197 4 233 23 201 28 184 30 169 28 153 48 145
Polygon -7500403 true true 171 181 178 263 187 277 197 273 202 267 187 260 186 236 194 167
Polygon -7500403 true true 187 163 195 240 214 260 222 256 222 248 212 245 205 230 205 155
Polygon -7500403 true true 223 75 226 58 245 44 244 68 233 73
Line -16777216 false 89 181 112 185
Line -16777216 false 31 150 47 118
Polygon -16777216 true false 235 90 250 91 255 99 248 98 244 92
Line -16777216 false 236 112 246 119
Polygon -16777216 true false 278 119 282 116 274 113
Line -16777216 false 189 201 203 161
Line -16777216 false 90 262 94 272
Line -16777216 false 110 246 119 252
Line -16777216 false 190 266 194 274
Line -16777216 false 218 251 219 257
Polygon -16777216 true false 230 67 228 54 222 62 224 72
Line -16777216 false 246 67 234 64
Line -16777216 false 229 45 235 68
Line -16777216 false 30 150 30 165

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 4.1.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
