import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

export default defineConfig({
  base: './', // or '/webUi/' for fixed repo path
  plugins: [react()],
})