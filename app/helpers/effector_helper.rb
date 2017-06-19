module DearFcc
  class App
    module EffectorHelper
      def sign_up_for_effector(filer)
        NewsletterWorker.delay(queue: "signups").signup(filer.fetch("email"), filer["zip_code"])
      end
    end

    helpers EffectorHelper
  end
end
