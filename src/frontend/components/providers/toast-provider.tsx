'use client'

import * as Toast from '@radix-ui/react-toast'

export function ToastProvider({ children }: { children: React.ReactNode }) {
  return (
    <Toast.Provider>
      {children}
      <Toast.Viewport className="fixed bottom-0 right-0 p-6 space-y-4" />
    </Toast.Provider>
  )
}