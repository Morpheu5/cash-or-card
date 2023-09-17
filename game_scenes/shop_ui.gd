extends CanvasLayer

@onready var bankLabel = %BankLabel
@onready var cashLabel = %CashLabel
@onready var insurancePremiumLabel = %InsurancePremiumLabel
@onready var insuranceExcessLabel = %InsuranceExcessLabel
@onready var incomeLossLabel = %IncomeLossLabel
@onready var electronicFeeLossLabel = %ElectronicFeeLossLabel
@onready var cashFeeLossLabel = %CashFeeLossLabel
@onready var robberyChanceLabel = %RobberyChanceLabel

@onready var customerNameLabel = %CustomerNameLabel
@onready var amountLabel = %AmountLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	bankLabel.text = "Banca: 0.00"
	cashLabel.text = "Contanti: 0.00"
	insurancePremiumLabel.text = "Assicurazione: 0.00"
	insuranceExcessLabel.text = "Franchigia: 0.00"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_shop_bank_changed(new_value):
	bankLabel.text = "Banca: %.2f" % new_value

func _on_shop_cash_changed(new_value):
	cashLabel.text = "Contanti: %.2f" % new_value

func _on_shop_insurance_premium_changed(new_value):
	insurancePremiumLabel.text = "Assicurazione: %.2f" % new_value
	
func _on_shop_insurance_excess_changed(new_value):
	insuranceExcessLabel.text = "Franchigia: %.2f" % new_value

func _on_shop_income_lost_changed(new_value):
	incomeLossLabel.text = "Mancati guadagni: %.2f" % new_value

func _on_shop_electronic_fee_loss_changed(new_value):
	electronicFeeLossLabel.text = "Costi elettronici: %.2f" % new_value

func _on_shop_cash_fee_loss_changed(new_value):
	cashFeeLossLabel.text = "Costi contante: %.2f" % new_value

func _on_shop_robbery_chance_changed(new_value):
	robberyChanceLabel.text = "Rischio rapina: %.1f %%" % (new_value * 100)

