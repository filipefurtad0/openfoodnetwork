require 'system_helper'

describe "visits", type: :system do 
  include ShopWorkflow
  include AuthenticationHelper
  include OpenFoodNetwork::ApiHelper
  include StripeHelper
  include StripeStubs
  include DownloadsHelper

  context "visitng the home page" do

    before do
      # visits the homepage and switches to EN locale 
      visit "https://staging.coopcircuits.fr/login#/locales/en_FR"

      # accepts cookies
      click_on "Accepter les cookies"

      # fills in Email
      fill_in "Email", with: "filipefurtado+baguettec@gmail.com"

      # fills in Password
      fill_in "Mot de passe", with: "baguettec123"

      # logs in
      click_on "Se connecter"
    end

    it "and logging in" do
      expect(page).to have_content "Vous êtes désormais connecté !"   
    end

    context "placing orders" do

      before do
        #visits the shop
        visit "https://staging.coopcircuits.fr/baguette/shop"
        sleep(1)

        # adds the first available item to the cart
        click_on "Ajouter"

        #clicks cart
        find("#cart").click

        sleep(1)

        # proceeds to checkout
        click_on "Etape suivante"

        # selects shipping method
        choose "Consigne automatique"

        # proceeds to payment step
        click_on "Etape suivante - Moyen de Paiement"
      end

      it "with Stripe" do

        # chooses Stripe SCA payment method
        choose "StripeSCA"

        # proceeds to Order summary
        click_on "Etape suivante - Récapitulatif de commande"

        # accepts terms and services
        check "J'accepte les Conditions Générales d'Utilisation de CoopCircuits."

        # places the order
        click_on "Valider ma commande"

        # redirects to Stripe for authentication
        click_on "Complete authentication"

        # displays the order confirmation banner
        expect(page).to have_content "Votre commande a été traitée avec succès"

      end

      it "cash" do

        # chooses Stripe SCA payment method
        choose "cash"

        # proceeds to Order summary
        click_on "Etape suivante - Récapitulatif de commande"

        # accepts terms and services
        check "J'accepte les Conditions Générales d'Utilisation de CoopCircuits."

        # places the order
        click_on "Valider ma commande"

        # redirects to Stripe for authentication
        click_on "Complete authentication"

        # displays the order confirmation banner
        expect(page).to have_content "Votre commande a été traitée avec succès"
      end
    end
  end
end
