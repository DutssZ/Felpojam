class_name CarimboResource
extends Resource

# Exports (configurações do Carimbo)
# Definir getters e setters

## Nome da configuração
@export var Nome := "Default"
## Dano causado pelo carimbo
@export var Dano := 10.0
## Tempo de cooldown/recarga do carimbo
@export var Cooldown := 5.0
## Distância máxima ao jogador
@export var Alcance := 2.5
## Multiplicador para a velocidade da animação de queda
@export var Velocidade := 1.0
## Mesh para esse carimbo
@export var CarimboMesh: Mesh
## Imagem que vai aparecer após o carimbo cair
@export var CarimboImage: Texture2D
## Outras configurações (propriedade: valor)
@export var Extras := {}
