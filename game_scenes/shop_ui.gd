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
	bankLabel.text = tr("Banca: %.2f") % 0
	cashLabel.text = tr("Contanti: %.2f") % 0
	insurancePremiumLabel.text = tr("Assicurazione: %.2f") % 0
	insuranceExcessLabel.text = tr("Franchigia: %.2f") % 0

func _on_shop_bank_changed(new_value):
	bankLabel.text = tr("Banca: %.2f") % new_value

func _on_shop_cash_changed(new_value):
	cashLabel.text = tr("Contanti: %.2f") % new_value

func _on_shop_insurance_premium_changed(new_value):
	insurancePremiumLabel.text = tr("Assicurazione: %.2f") % new_value
	
func _on_shop_insurance_excess_changed(new_value):
	insuranceExcessLabel.text = tr("Franchigia: %.2f") % new_value

func _on_shop_income_lost_changed(new_value):
	incomeLossLabel.text = tr("Mancati guadagni: %.2f") % new_value

func _on_shop_electronic_fee_loss_changed(new_value):
	electronicFeeLossLabel.text = tr("Costi elettronici: %.2f") % new_value

func _on_shop_cash_fee_loss_changed(new_value):
	cashFeeLossLabel.text = tr("Costi contanti: %.2f") % new_value

func _on_shop_robbery_chance_changed(new_value):
	robberyChanceLabel.text = tr("Rischio rapina: %.1f %%") % (new_value * 100)

