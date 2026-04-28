# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "react", to: "https://esm.sh/react@18.3.1"
pin "react-dom", to: "https://esm.sh/react-dom@18.3.1"
pin "react-dom/client", to: "https://esm.sh/react-dom@18.3.1/client"
pin "scheduler", to: "https://esm.sh/scheduler@0.23.2"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
pin_all_from "app/javascript/components", under: "components"
