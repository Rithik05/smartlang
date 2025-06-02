import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

const clientBuildDirectory = 'fe/dist'

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: path.resolve('../../priv/static', clientBuildDirectory),
    emptyOutDir: true
  }
})
